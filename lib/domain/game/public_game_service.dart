import 'dart:math' as math;

import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PublicGameService with LoggerMixin {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PublicGameService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  String _generateReadableId() {
    final random = math.Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';

    String randomPart1 = String.fromCharCodes(
      Iterable.generate(
        3,
        (_) => digits.codeUnitAt(random.nextInt(digits.length)),
      ),
    );
    String randomPart2 = String.fromCharCodes(
      Iterable.generate(
        3,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );

    return 'cabo-$randomPart1-$randomPart2';
  }

  /// Saves a game to Firestore and returns the new document ID.
  ///
  /// Throws an [Exception] if nobody is signed in. Publishing additionally
  /// requires a confirmed e-mail address, which is enforced by the security
  /// rules; the UI gates on ApplicationState.canPublishGame beforehand.
  ///
  /// Messages here are log-only: every caller shows its own localized text.
  Future<Game> saveOrUpdateGame({required Game game}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      logger.warning('User is not logged in. Cannot save game.');
      throw Exception('Cannot save a game without a signed in user.');
    }

    // A public game must have an owner.
    try {
      if (game.publicId != null) {
        logger.info('Updating game with publicId: ${game.publicId}');
        final DocumentReference<Map<String, dynamic>> docRef = _firestore
            .collection('games')
            .doc(game.publicId);
        // Merge inside a transaction so concurrent writes of other players do
        // not overwrite each other.
        final Game merged = await _firestore.runTransaction<Game>((
          Transaction tx,
        ) async {
          final DocumentSnapshot<Map<String, dynamic>> snapshot = await tx.get(
            docRef,
          );
          final Game effective = snapshot.exists
              ? _mergePlayers(Game.fromJson(snapshot.data()!), game)
              : game;
          tx.set(docRef, effective.toJson());
          return effective;
        });
        return merged;
      } else {
        String publicId;

        publicId = _generateReadableId();

        final gameWithPublicId = game.copyWith(
          publicId: publicId,
          ownerId: user.uid,
          playerUids: <String>[user.uid],
        );

        await _firestore
            .collection('games')
            .doc(publicId)
            .set(gameWithPublicId.toJson());
        logger.info('Game saved successfully with id: $publicId');
        return gameWithPublicId;
      }
    } on FirebaseException catch (e) {
      if (e.code == 'unauthenticated') {
        logger.warning(
          'Unauthenticated error received. Forcing user sign out.',
        );
        await _auth.signOut();
        // Every user is expected to be signed in, so restore that right away.
        await _auth.signInAnonymously();
        throw Exception('Session expired, signed the user out.');
      }
      rethrow;
    }
  }

  /// Adds the UID of the signed in (possibly anonymous) user to `playerUids`.
  Future<Game> joinGame(String publicId) async {
    User? user = _auth.currentUser;
    user ??= (await _auth.signInAnonymously()).user;

    if (user == null) {
      throw Exception('Could not sign in to join the game.');
    }

    final String uid = user.uid;
    final DocumentReference<Map<String, dynamic>> docRef = _firestore
        .collection('games')
        .doc(publicId);
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception('No game exists with id $publicId.');
    }

    final Game current = Game.fromJson(snapshot.data()!);
    if (current.playerUids.contains(uid)) {
      return current;
    }

    // arrayUnion is atomic on the server, so no transaction is needed here.
    await docRef.update(<String, Object>{
      'playerUids': FieldValue.arrayUnion(<String>[uid]),
    });

    return current.copyWith(playerUids: <String>[...current.playerUids, uid]);
  }

  /// Merges the rounds per player (the player with the longer round list
  /// wins) so that concurrent writes do not overwrite each other.
  Game _mergePlayers(Game remote, Game local) {
    final Map<String, Player> localByName = <String, Player>{
      for (final Player p in local.players) p.name: p,
    };
    final Map<String, Player> remoteByName = <String, Player>{
      for (final Player p in remote.players) p.name: p,
    };
    final Set<String> allNames = <String>{
      ...localByName.keys,
      ...remoteByName.keys,
    };

    final List<Player> merged = <Player>[];
    for (final String name in allNames) {
      final Player? lp = localByName[name];
      final Player? rp = remoteByName[name];
      if (lp == null) {
        merged.add(rp!);
      } else if (rp == null) {
        merged.add(lp);
      } else {
        merged.add(lp.rounds.length >= rp.rounds.length ? lp : rp);
      }
    }
    merged.sort((Player a, Player b) => a.totalPoints.compareTo(b.totalPoints));
    for (int i = 0; i < merged.length; i++) {
      merged[i] = merged[i].copyWith(place: i + 1);
    }
    final List<String> mergedUids = <String>{
      ...remote.playerUids,
      ...local.playerUids,
    }.toList();
    return local.copyWith(
      players: merged,
      playerUids: mergedUids,
      finishedAt: local.finishedAt ?? remote.finishedAt,
    );
  }

  /// Removes a published game again. The security rules only grant this to
  /// the owner, so every other caller runs into a permission error.
  Future<void> deleteGame(String publicId) async {
    await _firestore.collection('games').doc(publicId).delete();
    logger.info('Deleted public game with id: $publicId');
  }

  Future<Game> getPublicGame(String publicId) async {
    return _firestore
        .collection('games')
        .doc(publicId)
        .get()
        .then((snapshot) => Game.fromJson(snapshot.data()!));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> subscribeToGame(
    String publicId,
  ) {
    return _firestore.collection('games').doc(publicId).snapshots();
  }
}
