import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/domain/application/local_application_repository.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> with LoggerMixin {
  ApplicationCubit({required this.repository})
    : super(const ApplicationInitial()) {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
      User? user,
    ) {
      if (user == null) {
        emit(ApplicationUnauthenticated(isDeveloper: state.isDeveloper));
      } else {
        emit(
          ApplicationAuthenticated(user: user, isDeveloper: state.isDeveloper),
        );
      }
    });

    unawaited(signIn.initialize());
  }

  late final StreamSubscription<User?> _authSubscription;
  final LocalApplicationRepository repository;
  final GoogleSignIn signIn = GoogleSignIn.instance;

  void init() async {
    final isDeveloperMode = await repository.getCurrent() ?? false;
    emit(state.copyWith(isDeveloper: isDeveloperMode));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Signs in the user anonymously using Firebase.
  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      logger.severe(
        'Error signing in anonymously: ${e.message}',
        e,
        e.stackTrace,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      const List<String> scopes = <String>[
        'https://www.googleapis.com/auth/userinfo.email',
      ];

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate(scopeHint: scopes);

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final GoogleSignInAuthorizationClient authClient =
          signIn.authorizationClient;
      final GoogleSignInClientAuthorization? authorization = await authClient
          .authorizationForScopes(scopes);

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        logger.info('Successfully signed in with Google: ${user.displayName}');
      } else {
        logger.warning('Google sign in resulted in a null user.');
      }
    } on FirebaseAuthException catch (e) {
      logger.severe(
        'Error during Google sign-in: ${e.message}',
        e,
        e.stackTrace,
      );
    } catch (e, stackTrace) {
      logger.severe('An unexpected error occurred: $e', e, stackTrace);
    }
  }

  GoogleSignInAuthentication getAuthTokens(GoogleSignInAccount account) {
    return account.authentication;
  }

  void saveIsDeveloperMode(bool isDeveloperMode) {
    repository.saveCurrent(isDeveloperMode);
    emit(state.copyWith(isDeveloper: isDeveloperMode));
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }

  void toggleDeveloperMode() {
    final bool newMode = !state.isDeveloper;
    saveIsDeveloperMode(newMode);
  }
}
