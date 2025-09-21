import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> with LoggerMixin {
  ApplicationCubit() : super(ApplicationInitial()) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      if (user == null) {
        emit(ApplicationUnauthenticated());
      } else {
        emit(ApplicationAuthenticated(user));
      }
    });
  }

  late final StreamSubscription<User?> _authSubscription;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Signs in the user anonymously using Firebase.
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      log.severe('Error signing in anonymously: ${e.message}', e, e.stackTrace);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // 1. Starte den Google-Anmeldevorgang auf dem Gerät
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Wenn der Benutzer den Vorgang abbricht, ist googleUser null
      if (googleUser == null) {
        return;
      }

      // 2. Hole die Authentifizierungsdetails (Tokens) vom Google-Konto
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Erstelle ein Firebase-Credential mit den Tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      // Fehlerbehandlung für Firebase-spezifische Fehler
      log.severe('Error during Google sign-in: ${e.message}', e);
    } catch (e) {
      // Allgemeine Fehlerbehandlung (z.B. Netzwerkprobleme)
      log.severe('An unexpected error occurred: $e');
    }
  }

  Future<String?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Password oder Email falsch.';
      }
      if (e.code == 'wrong-password') {
        return 'Password oder Email falsch.';
      }
    }
    return null;
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      // First, try to sign in the user.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // If the user is not found, create a new account.
      if (e.code == 'user-not-found') {
        try {
          final currentUser = FirebaseAuth.instance.currentUser;
          // If an anonymous user is signed in, link the account.
          if (currentUser != null && currentUser.isAnonymous) {
            final credential = EmailAuthProvider.credential(
              email: email,
              password: password,
            );
            await currentUser.linkWithCredential(credential);
          } else {
            // Otherwise, create a completely new user.
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
          }
        } on FirebaseAuthException catch (e) {
          log.severe('Error during registration: ${e.message}', e);
          rethrow;
        }
      } else {
        log.severe('Error during sign in: ${e.message}', e);
        rethrow;
      }
    } catch (e) {
      log.severe('An unexpected error occurred: $e');
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
