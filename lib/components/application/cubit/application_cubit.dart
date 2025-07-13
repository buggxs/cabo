import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationInitial()) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
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
      // Hier könntest du einen Fehlerzustand ausgeben oder ein Logging durchführen
      // z.B. emit(ApplicationAuthError('Failed to sign in anonymously.'));
      print(e.message);
      print(e.stackTrace);
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
    } on FirebaseAuthException {
      // Fehlerbehandlung für Firebase-spezifische Fehler
    } catch (e) {
      // Allgemeine Fehlerbehandlung (z.B. Netzwerkprobleme)
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
