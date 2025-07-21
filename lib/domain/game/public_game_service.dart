import 'package:cabo/domain/game/game.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PublicGameService with LoggerMixin {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PublicGameService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Saves a game to Firestore and returns the new document ID.
  ///
  /// Throws an [Exception] if the user is not logged in, or if an
  /// anonymous user tries to create a public game.
  Future<Game> saveOrUpdateGame({required Game game}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      log.warning('User is not logged in. Cannot save game.');
      throw Exception('Um ein Spiel zu speichern, musst du angemeldet sein.');
    }

    // A public game must have an owner.
    Game gameToSave = game.copyWith(ownerId: user.uid);

    if (gameToSave.publicId != null) {
      log.info('Updating game with publicId: ${gameToSave.publicId}');
      await _firestore
          .collection('games')
          .doc(gameToSave.publicId)
          .set(gameToSave.toJson());
      return gameToSave;
    } else {
      final docRef =
          await _firestore.collection('games').add(gameToSave.toJson());
      log.info('Game saved successfully with id: ${docRef.id}');
      return gameToSave.copyWith(publicId: docRef.id);
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
      String publicId) {
    return _firestore.collection('games').doc(publicId).snapshots();
  }
}
