import 'package:cabo/domain/application/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

// Renamed to avoid clashing with firebase_auth_mocks' MockFirebaseAuth/MockUser.
@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<FirebaseAuth>(as: #MockitoFirebaseAuth),
  MockSpec<User>(as: #MockitoUser),
  MockSpec<UserCredential>(as: #MockitoUserCredential),
])
void main() {
  group('AuthService.ensureSignedIn', () {
    test('signs in anonymously when nobody is signed in', () async {
      final MockFirebaseAuth auth = MockFirebaseAuth();
      final AuthService service = AuthService(auth: auth);

      final AuthOutcome outcome = await service.ensureSignedIn();

      expect(outcome.isSuccess, isTrue);
      expect(auth.currentUser, isNotNull);
      expect(auth.currentUser!.isAnonymous, isTrue);
    });

    test('is idempotent and keeps the existing user', () async {
      final MockUser existing = MockUser(uid: 'existing-uid');
      final MockFirebaseAuth auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: existing,
      );
      final AuthService service = AuthService(auth: auth);

      final AuthOutcome outcome = await service.ensureSignedIn();

      expect(outcome.isSuccess, isTrue);
      expect(auth.currentUser!.uid, 'existing-uid');
    });

    test('reports a network failure without throwing', () async {
      final MockFirebaseAuth auth = MockFirebaseAuth();
      whenCalling(Invocation.method(#signInAnonymously, null))
          .on(auth)
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      final AuthService service = AuthService(auth: auth);

      final AuthOutcome outcome = await service.ensureSignedIn();

      expect(outcome.isSuccess, isFalse);
      expect(outcome.error, AuthError.network);
    });
  });

  group('AuthService.registerWithEmail', () {
    // Mockito instead of MockUser: firebase_auth_mocks cannot link an
    // anonymous user at all -- MockUser.linkWithCredential builds a
    // MockUserCredential(false) and asserts isAnonymous matches, which always
    // trips for an anonymous user.
    late MockitoFirebaseAuth auth;
    late MockitoUser user;
    late AuthService service;

    setUp(() {
      auth = MockitoFirebaseAuth();
      user = MockitoUser();
      service = AuthService(auth: auth);
      when(auth.currentUser).thenReturn(user);
      when(
        user.linkWithCredential(any),
      ).thenAnswer((_) async => MockitoUserCredential());
      when(user.sendEmailVerification(any)).thenAnswer((_) async {});
    });

    test('links onto the anonymous user and keeps the uid', () async {
      when(user.isAnonymous).thenReturn(true);
      when(user.uid).thenReturn('anonymous-uid');

      final AuthOutcome outcome = await service.registerWithEmail(
        email: 'player@example.com',
        password: 'sup3rSecret',
      );

      expect(outcome.isSuccess, isTrue);
      verify(user.linkWithCredential(any)).called(1);
      verifyNever(
        auth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      expect(auth.currentUser!.uid, 'anonymous-uid');
    });

    test('creates a fresh account when nobody is signed in', () async {
      when(auth.currentUser).thenReturn(null);
      when(
        auth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => MockitoUserCredential());

      final AuthOutcome outcome = await service.registerWithEmail(
        email: 'player@example.com',
        password: 'sup3rSecret',
      );

      // currentUser stays null in this mock, so sending the mail cannot work.
      expect(outcome.isSuccess, isFalse);
      verify(
        auth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).called(1);
      verifyNever(user.linkWithCredential(any));
    });

    test('reports emailAlreadyInUse instead of switching the uid', () async {
      when(user.isAnonymous).thenReturn(true);
      when(user.uid).thenReturn('anonymous-uid');
      when(
        user.linkWithCredential(any),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      final AuthOutcome outcome = await service.registerWithEmail(
        email: 'taken@example.com',
        password: 'sup3rSecret',
      );

      expect(outcome.error, AuthError.emailAlreadyInUse);
      verifyNever(
        auth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      expect(auth.currentUser!.uid, 'anonymous-uid');
    });

    test('maps a weak password to a field level error', () async {
      when(user.isAnonymous).thenReturn(true);
      when(
        user.linkWithCredential(any),
      ).thenThrow(FirebaseAuthException(code: 'weak-password'));

      final AuthOutcome outcome = await service.registerWithEmail(
        email: 'player@example.com',
        password: '123',
      );

      expect(outcome.error, AuthError.weakPassword);
    });
  });

  group('AuthService.signInWithEmail', () {
    test('maps wrong credentials to invalidCredentials', () async {
      final MockFirebaseAuth auth = MockFirebaseAuth();
      whenCalling(
        Invocation.method(#signInWithEmailAndPassword, null),
      ).on(auth).thenThrow(FirebaseAuthException(code: 'wrong-password'));
      final AuthService service = AuthService(auth: auth);

      final AuthOutcome outcome = await service.signInWithEmail(
        email: 'player@example.com',
        password: 'nope',
      );

      expect(outcome.error, AuthError.invalidCredentials);
    });
  });

  group('AuthService.refreshVerificationStatus', () {
    test(
      'forces an ID token refresh so the rules see email_verified',
      () async {
        // Mockito instead of MockUser: emailVerified is final on the fake, and
        // the forced refresh is exactly what needs verifying here.
        final MockitoFirebaseAuth auth = MockitoFirebaseAuth();
        final MockitoUser user = MockitoUser();
        when(auth.currentUser).thenReturn(user);
        when(user.reload()).thenAnswer((_) async {});
        when(user.getIdToken(true)).thenAnswer((_) async => 'fresh-token');
        when(user.emailVerified).thenReturn(true);
        final AuthService service = AuthService(auth: auth);

        final bool isVerified = await service.refreshVerificationStatus();

        expect(isVerified, isTrue);
        verify(user.reload()).called(1);
        verify(user.getIdToken(true)).called(1);
      },
    );

    test('returns false when nobody is signed in', () async {
      final MockitoFirebaseAuth auth = MockitoFirebaseAuth();
      when(auth.currentUser).thenReturn(null);
      final AuthService service = AuthService(auth: auth);

      expect(await service.refreshVerificationStatus(), isFalse);
    });

    test('returns false when the refresh fails', () async {
      final MockitoFirebaseAuth auth = MockitoFirebaseAuth();
      final MockitoUser user = MockitoUser();
      when(auth.currentUser).thenReturn(user);
      when(
        user.reload(),
      ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
      final AuthService service = AuthService(auth: auth);

      expect(await service.refreshVerificationStatus(), isFalse);
    });
  });
}
