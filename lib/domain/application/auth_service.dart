import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthError {
  /// Client side validation only, never returned by Firebase.
  passwordMismatch,
  emailRequired,
  passwordRequired,
  invalidCredentials,
  emailAlreadyInUse,
  credentialAlreadyInUse,
  providerAlreadyLinked,
  weakPassword,
  invalidEmail,
  tooManyRequests,
  network,
  cancelled,
  unknown,
}

class AuthOutcome extends Equatable {
  const AuthOutcome.success() : error = null;

  const AuthOutcome.failure(this.error);

  final AuthError? error;

  bool get isSuccess => error == null;

  @override
  List<Object?> get props => <Object?>[error];
}

/// Wraps Firebase Auth so the rest of the app never touches
/// [FirebaseAuth.instance] directly and stays testable.
class AuthService with LoggerMixin {
  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFunctions? functions,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
       _functionsOverride = functions;

  static const String _functionsRegion = 'europe-west1';

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  FirebaseFunctions? _functionsOverride;

  // Resolved on first use: building it eagerly would require an initialised
  // Firebase app in every test that never sends a mail.
  FirebaseFunctions get _functions => _functionsOverride ??=
      FirebaseFunctions.instanceFor(region: _functionsRegion);

  Future<void>? _providerInitialization;

  static const List<String> _googleScopes = <String>[
    'https://www.googleapis.com/auth/userinfo.email',
  ];

  User? get currentUser => _auth.currentUser;

  /// Superset of authStateChanges: also fires when credentials are linked
  /// and when the ID token is refreshed.
  Stream<User?> userChanges() => _auth.userChanges();

  /// Memoized so a sign-in tapped before initialization finished waits for it
  /// instead of failing.
  Future<void> initializeProviders() {
    return _providerInitialization ??= _googleSignIn.initialize().catchError((
      Object e,
    ) {
      logger.severe('Could not initialize sign-in providers', e);
      _providerInitialization = null;
    });
  }

  /// Idempotent anonymous bootstrap. Never throws, so local play stays
  /// available when the device is offline.
  Future<AuthOutcome> ensureSignedIn() async {
    if (_auth.currentUser != null) {
      return const AuthOutcome.success();
    }
    try {
      await _auth.signInAnonymously();
      return const AuthOutcome.success();
    } on FirebaseAuthException catch (e) {
      logger.warning('Anonymous sign-in failed: ${e.code} ${e.message}');
      return AuthOutcome.failure(_mapError(e));
    } catch (e, stackTrace) {
      logger.severe('Unexpected error during anonymous sign-in', e, stackTrace);
      return const AuthOutcome.failure(AuthError.unknown);
    }
  }

  Future<AuthOutcome> signInWithGoogle() async {
    try {
      await initializeProviders();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: _googleScopes,
      );
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final GoogleSignInClientAuthorization? authorization = await _googleSignIn
          .authorizationClient
          .authorizationForScopes(_googleScopes);

      if (authorization == null) {
        logger.warning('Google sign-in: authorization for scopes was null.');
        return const AuthOutcome.failure(AuthError.cancelled);
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      return _linkOrSignIn(credential);
    } on FirebaseAuthException catch (e) {
      logger.severe('Error during Google sign-in: ${e.message}', e);
      return AuthOutcome.failure(_mapError(e));
    } on GoogleSignInException catch (e) {
      logger.warning('Google sign-in aborted: ${e.code}');
      return const AuthOutcome.failure(AuthError.cancelled);
    } catch (e, stackTrace) {
      logger.severe('Unexpected error during Google sign-in', e, stackTrace);
      return const AuthOutcome.failure(AuthError.unknown);
    }
  }

  /// Links the e-mail credential onto the current anonymous user so the UID
  /// and therefore all existing games are kept.
  Future<AuthOutcome> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final User? current = _auth.currentUser;
    try {
      if (current != null && current.isAnonymous) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await current.linkWithCredential(credential);
      } else {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      return const AuthOutcome.success();
    } on FirebaseAuthException catch (e) {
      logger.warning('Registration failed: ${e.code}');
      return AuthOutcome.failure(_mapError(e));
    } catch (e, stackTrace) {
      logger.severe('Unexpected error during registration', e, stackTrace);
      return const AuthOutcome.failure(AuthError.unknown);
    }
  }

  /// Signs in with an existing account. This replaces the current anonymous
  /// user, so games owned by the anonymous UID become inaccessible.
  Future<AuthOutcome> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return const AuthOutcome.success();
    } on FirebaseAuthException catch (e) {
      logger.warning('E-mail sign-in failed: ${e.code}');
      return AuthOutcome.failure(_mapError(e));
    } catch (e, stackTrace) {
      logger.severe('Unexpected error during e-mail sign-in', e, stackTrace);
      return const AuthOutcome.failure(AuthError.unknown);
    }
  }

  /// Sent by our own Cloud Function rather than by Firebase.
  ///
  /// Firebase refuses to let this project edit its auth email templates, and
  /// the default one renders the raw action URL as the link text -- which
  /// reads as phishing. The function builds the link against our own handler
  /// and sends a branded mail instead.
  Future<AuthOutcome> sendVerificationEmail() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return const AuthOutcome.failure(AuthError.unknown);
    }
    return _callMailFunction('sendVerificationEmail');
  }

  Future<AuthOutcome> _callMailFunction(
    String name, [
    Map<String, dynamic>? payload,
  ]) async {
    try {
      await _functions.httpsCallable(name).call<void>(payload);
      return const AuthOutcome.success();
    } on FirebaseFunctionsException catch (e) {
      logger.warning('Mail function $name failed: ${e.code} ${e.message}');
      return AuthOutcome.failure(_mapFunctionError(e));
    } catch (e, stackTrace) {
      logger.severe('Unexpected error calling $name', e, stackTrace);
      return const AuthOutcome.failure(AuthError.unknown);
    }
  }

  AuthError _mapFunctionError(FirebaseFunctionsException exception) {
    switch (exception.code) {
      case 'resource-exhausted':
        return AuthError.tooManyRequests;
      case 'invalid-argument':
        return AuthError.invalidEmail;
      case 'unauthenticated':
        return AuthError.invalidCredentials;
      case 'unavailable':
      case 'deadline-exceeded':
        return AuthError.network;
      default:
        return AuthError.unknown;
    }
  }

  Future<bool> refreshVerificationStatus() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      await user.reload();
      // Mandatory: reload() only refreshes the local User object. The ID token
      // that Firestore rules evaluate still carries email_verified: false.
      await _auth.currentUser?.getIdToken(true);
      return _auth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      logger.warning('Could not refresh verification status: ${e.message}');
      return false;
    }
  }

  Future<AuthOutcome> sendPasswordResetEmail(String email) {
    return _callMailFunction('sendPasswordResetEmail', <String, dynamic>{
      'email': email,
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Links onto the anonymous user so the UID survives. Since everybody is
  /// signed in anonymously, this is the normal path -- and it fails for anyone
  /// who already owns this provider account, so fall back to a plain sign-in.
  /// That drops the anonymous UID, which only holds games created on this
  /// device before signing in.
  Future<AuthOutcome> _linkOrSignIn(AuthCredential credential) async {
    final User? current = _auth.currentUser;
    if (current == null || !current.isAnonymous) {
      await _auth.signInWithCredential(credential);
      return const AuthOutcome.success();
    }
    try {
      await current.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (!_isAccountConflict(e.code)) {
        rethrow;
      }
      logger.info('Account already exists (${e.code}), signing in instead.');
      await _auth.signInWithCredential(credential);
    }
    return const AuthOutcome.success();
  }

  @visibleForTesting
  Future<AuthOutcome> linkOrSignInForTest(AuthCredential credential) =>
      _linkOrSignIn(credential);

  bool _isAccountConflict(String code) {
    return code == 'credential-already-in-use' ||
        code == 'email-already-in-use' ||
        code == 'provider-already-linked';
  }

  AuthError _mapError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AuthError.invalidCredentials;
      case 'email-already-in-use':
        return AuthError.emailAlreadyInUse;
      case 'credential-already-in-use':
        return AuthError.credentialAlreadyInUse;
      case 'provider-already-linked':
        return AuthError.providerAlreadyLinked;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'too-many-requests':
        return AuthError.tooManyRequests;
      case 'network-request-failed':
        return AuthError.network;
      default:
        return AuthError.unknown;
    }
  }
}
