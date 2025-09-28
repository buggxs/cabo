import 'dart:math' as math;

import 'package:cabo/domain/game/game.dart';
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
  /// Throws an [Exception] if the user is not logged in, or if an
  /// anonymous user tries to create a public game.
  Future<Game> saveOrUpdateGame({required Game game}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      logger.warning('User is not logged in. Cannot save game.');
      throw Exception('Um ein Spiel zu speichern, musst du angemeldet sein.');
    }

    // A public game must have an owner.
    Game gameToSave = game.copyWith(ownerId: user.uid);
    try {
      if (gameToSave.publicId != null) {
        logger.info('Updating game with publicId: ${gameToSave.publicId}');
        await _firestore
            .collection('games')
            .doc(gameToSave.publicId)
            .set(gameToSave.toJson());
        return gameToSave;
      } else {
        String publicId;

        publicId = _generateReadableId();

        final gameWithPublicId = gameToSave.copyWith(publicId: publicId);

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
        throw Exception(
          'Deine Anmeldung ist abgelaufen. Bitte melde dich erneut an.',
        );
      }
      rethrow;
    }
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
