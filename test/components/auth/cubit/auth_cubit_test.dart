import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<AuthService>()])
void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
    when(
      authService.registerWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      authService.signInWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      authService.sendVerificationEmail(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(authService.refreshVerificationStatus()).thenAnswer((_) async => true);
    when(
      authService.signInWithGoogle(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      authService.sendPasswordResetEmail(any),
    ).thenAnswer((_) async => const AuthOutcome.success());
  });

  AuthCubit buildCubit() => AuthCubit(authService: authService);

  group('AuthCubit mode switching', () {
    blocTest<AuthCubit, AuthFormState>(
      'moves from the chooser to sign in and back',
      build: buildCubit,
      act: (AuthCubit cubit) {
        cubit.showSignIn();
        cubit.showRegister();
        cubit.showChooser();
      },
      expect: () => <Matcher>[
        isA<AuthFormState>().having(
          (AuthFormState s) => s.mode,
          'mode',
          AuthMode.signIn,
        ),
        isA<AuthFormState>().having(
          (AuthFormState s) => s.mode,
          'mode',
          AuthMode.register,
        ),
        isA<AuthFormState>().having(
          (AuthFormState s) => s.mode,
          'mode',
          AuthMode.chooser,
        ),
      ],
    );
  });

  group('AuthCubit validation', () {
    test('rejects a malformed e-mail before calling the service', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(email: 'not-an-email', password: 'sup3rSecret');

      expect(cubit.state.emailFieldError, AuthError.invalidEmail);
      verifyNever(
        authService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      await cubit.close();
    });

    test('rejects an empty password before calling the service', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(email: 'player@example.com', password: '');

      expect(cubit.state.passwordFieldError, AuthError.passwordRequired);
      verifyNever(
        authService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      await cubit.close();
    });

    test('lets a short password through when signing in', () async {
      // Accounts created before the minimum was raised must still be able to
      // sign in -- Firebase itself allows six characters.
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(email: 'player@example.com', password: 'sechs1');

      expect(cubit.state.passwordFieldError, isNull);
      verify(
        authService.signInWithEmail(
          email: 'player@example.com',
          password: 'sechs1',
        ),
      ).called(1);
      await cubit.close();
    });

    test('rejects a short password when registering', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'player@example.com',
        password: 'sieben7',
        passwordRepeat: 'sieben7',
      );

      expect(cubit.state.passwordFieldError, AuthError.weakPassword);
      verifyNever(
        authService.registerWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      await cubit.close();
    });

    test('rejects mismatching passwords without registering', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'somethingElse',
      );

      expect(cubit.state.passwordFieldError, AuthError.passwordMismatch);
      verifyNever(
        authService.registerWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      await cubit.close();
    });

    test('trims the e-mail before passing it on', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(
        email: '  player@example.com  ',
        password: 'sup3rSecret',
      );

      verify(
        authService.signInWithEmail(
          email: 'player@example.com',
          password: 'sup3rSecret',
        ),
      ).called(1);
      await cubit.close();
    });
  });

  group('AuthCubit registration', () {
    test('starts the resend cooldown after a successful register', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(cubit.state.error, isNull);
      expect(cubit.state.resendCooldown, AuthCubit.resendCooldownSeconds);
      expect(cubit.state.canResendVerification, isFalse);
      expect(cubit.state.hasVerificationMailBeenSent, isTrue);
      await cubit.close();
    });

    test('surfaces an e-mail conflict instead of switching accounts', () async {
      when(
        authService.registerWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.emailAlreadyInUse),
      );
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'taken@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(cubit.state.hasEmailConflict, isTrue);
      expect(cubit.state.error, AuthError.emailAlreadyInUse);
      verifyNever(
        authService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      );
      await cubit.close();
    });

    test('maps a credential conflict to the same conflict state', () async {
      when(
        authService.registerWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer(
        (_) async =>
            const AuthOutcome.failure(AuthError.credentialAlreadyInUse),
      );
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'taken@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(cubit.state.hasEmailConflict, isTrue);
      await cubit.close();
    });
  });

  group('AuthCubit registration mail handling', () {
    test('reports success but surfaces a failing mail', () async {
      // Regression guard: registerWithEmail used to return the mail sending
      // result, so a created account was reported as a failure while the
      // notice already claimed a mail had gone out.
      when(authService.sendVerificationEmail()).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.tooManyRequests),
      );
      final AuthCubit cubit = buildCubit();

      await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      verify(authService.sendVerificationEmail()).called(1);
      expect(cubit.state.hasVerificationMailBeenSent, isFalse);
      expect(cubit.state.error, AuthError.tooManyRequests);
      expect(cubit.state.resendCooldown, 0);
      await cubit.close();
    });

    test(
      'does not send a mail when the account could not be created',
      () async {
        when(
          authService.registerWithEmail(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer(
          (_) async => const AuthOutcome.failure(AuthError.weakPassword),
        );
        final AuthCubit cubit = buildCubit();

        await cubit.register(
          email: 'player@example.com',
          password: 'sup3rSecret',
          passwordRepeat: 'sup3rSecret',
        );

        expect(cubit.state.error, AuthError.weakPassword);
        verifyNever(authService.sendVerificationEmail());
        await cubit.close();
      },
    );
  });

  group('AuthCubit google', () {
    test('a cancelled sheet is not reported as an error', () async {
      when(
        authService.signInWithGoogle(),
      ).thenAnswer((_) async => const AuthOutcome.failure(AuthError.cancelled));
      final AuthCubit cubit = buildCubit();

      await cubit.signInWithGoogle();

      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.error, isNull);
      await cubit.close();
    });

    test('a real failure keeps its reason', () async {
      when(
        authService.signInWithGoogle(),
      ).thenAnswer((_) async => const AuthOutcome.failure(AuthError.network));
      final AuthCubit cubit = buildCubit();

      await cubit.signInWithGoogle();

      expect(cubit.state.error, AuthError.network);
      await cubit.close();
    });
  });

  group('AuthCubit resend', () {
    test('does nothing while the cooldown is running', () async {
      final AuthCubit cubit = buildCubit();
      await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );
      // register already sent one mail
      clearInteractions(authService);

      await cubit.resendVerificationEmail();

      verifyNever(authService.sendVerificationEmail());
      await cubit.close();
    });

    test('sends again when no cooldown is active', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.resendVerificationEmail();

      verify(authService.sendVerificationEmail()).called(1);
      expect(cubit.state.hasVerificationMailBeenSent, isTrue);
      expect(cubit.state.resendCooldown, AuthCubit.resendCooldownSeconds);
      await cubit.close();
    });

    test('reports a rate limit as an error', () async {
      when(authService.sendVerificationEmail()).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.tooManyRequests),
      );
      final AuthCubit cubit = buildCubit();

      await cubit.resendVerificationEmail();

      expect(cubit.state.error, AuthError.tooManyRequests);
      expect(cubit.state.hasVerificationMailBeenSent, isFalse);
      expect(cubit.state.resendCooldown, 0);
      await cubit.close();
    });
  });

  group('AuthCubit closing mid-flight', () {
    test('checkVerification does not emit after close', () async {
      final Completer<bool> pending = Completer<bool>();
      when(
        authService.refreshVerificationStatus(),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.checkVerification();
      // The verification succeeding tears down the widget that owns this
      // cubit, so it closes while the call is still running.
      await cubit.close();
      pending.complete(true);

      await expectLater(inFlight, completes);
    });

    test('signIn does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        authService.signInWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.signIn(
        email: 'player@example.com',
        password: 'sup3rSecret',
      );
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completes);
    });

    test('register does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        authService.registerWithEmail(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completes);
    });

    test('resendVerificationEmail does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        authService.sendVerificationEmail(),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.resendVerificationEmail();
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completes);
    });

    test('signInWithGoogle does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(authService.signInWithGoogle()).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.signInWithGoogle();
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completes);
    });
  });

  group('AuthCubit.checkVerification', () {
    test('delegates to the auth service', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.checkVerification();

      expect(cubit.state.isVerificationPending, isFalse);
      verify(authService.refreshVerificationStatus()).called(1);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('reports a still unverified address', () async {
      when(
        authService.refreshVerificationStatus(),
      ).thenAnswer((_) async => false);
      final AuthCubit cubit = buildCubit();

      await cubit.checkVerification();

      expect(cubit.state.isVerificationPending, isTrue);
      await cubit.close();
    });
  });
}
