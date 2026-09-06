import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<ApplicationCubit>()])
void main() {
  late MockApplicationCubit applicationCubit;

  setUp(() {
    applicationCubit = MockApplicationCubit();
    when(
      applicationCubit.registerWithEmail(any, any),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      applicationCubit.signInWithEmail(any, any),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      applicationCubit.sendVerificationEmail(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      applicationCubit.refreshVerificationStatus(),
    ).thenAnswer((_) async => true);
    when(
      applicationCubit.signInWithGoogle(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      applicationCubit.sendPasswordResetEmail(any),
    ).thenAnswer((_) async => const AuthOutcome.success());
  });

  AuthCubit buildCubit() => AuthCubit(applicationCubit: applicationCubit);

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

      final bool isSuccess = await cubit.signIn(
        email: 'not-an-email',
        password: 'sup3rSecret',
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.emailFieldError, AuthError.invalidEmail);
      verifyNever(applicationCubit.signInWithEmail(any, any));
      await cubit.close();
    });

    test('rejects an empty password before calling the service', () async {
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.signIn(
        email: 'player@example.com',
        password: '',
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.passwordFieldError, AuthError.passwordRequired);
      verifyNever(applicationCubit.signInWithEmail(any, any));
      await cubit.close();
    });

    test('lets a short password through when signing in', () async {
      // Accounts created before the minimum was raised must still be able to
      // sign in -- Firebase itself allows six characters.
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(email: 'player@example.com', password: 'sechs1');

      expect(cubit.state.passwordFieldError, isNull);
      verify(
        applicationCubit.signInWithEmail('player@example.com', 'sechs1'),
      ).called(1);
      await cubit.close();
    });

    test('rejects a short password when registering', () async {
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.register(
        email: 'player@example.com',
        password: 'sieben7',
        passwordRepeat: 'sieben7',
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.passwordFieldError, AuthError.weakPassword);
      verifyNever(applicationCubit.registerWithEmail(any, any));
      await cubit.close();
    });

    test('rejects mismatching passwords without registering', () async {
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'somethingElse',
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.passwordFieldError, AuthError.passwordMismatch);
      verifyNever(applicationCubit.registerWithEmail(any, any));
      await cubit.close();
    });

    test('trims the e-mail before passing it on', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.signIn(
        email: '  player@example.com  ',
        password: 'sup3rSecret',
      );

      verify(
        applicationCubit.signInWithEmail('player@example.com', 'sup3rSecret'),
      ).called(1);
      await cubit.close();
    });
  });

  group('AuthCubit registration', () {
    test('starts the resend cooldown after a successful register', () async {
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(isSuccess, isTrue);
      expect(cubit.state.resendCooldown, AuthCubit.resendCooldownSeconds);
      expect(cubit.state.canResendVerification, isFalse);
      expect(cubit.state.hasVerificationMailBeenSent, isTrue);
      await cubit.close();
    });

    test('surfaces an e-mail conflict instead of switching accounts', () async {
      when(applicationCubit.registerWithEmail(any, any)).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.emailAlreadyInUse),
      );
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.register(
        email: 'taken@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(isSuccess, isFalse);
      expect(cubit.state.hasEmailConflict, isTrue);
      expect(cubit.state.error, AuthError.emailAlreadyInUse);
      verifyNever(applicationCubit.signInWithEmail(any, any));
      await cubit.close();
    });

    test('maps a credential conflict to the same conflict state', () async {
      when(applicationCubit.registerWithEmail(any, any)).thenAnswer(
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
      when(applicationCubit.sendVerificationEmail()).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.tooManyRequests),
      );
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );

      expect(isSuccess, isTrue);
      expect(cubit.state.hasVerificationMailBeenSent, isFalse);
      expect(cubit.state.error, AuthError.tooManyRequests);
      expect(cubit.state.resendCooldown, 0);
      await cubit.close();
    });

    test(
      'does not send a mail when the account could not be created',
      () async {
        when(applicationCubit.registerWithEmail(any, any)).thenAnswer(
          (_) async => const AuthOutcome.failure(AuthError.weakPassword),
        );
        final AuthCubit cubit = buildCubit();

        final bool isSuccess = await cubit.register(
          email: 'player@example.com',
          password: 'sup3rSecret',
          passwordRepeat: 'sup3rSecret',
        );

        expect(isSuccess, isFalse);
        verifyNever(applicationCubit.sendVerificationEmail());
        await cubit.close();
      },
    );
  });

  group('AuthCubit google', () {
    test('a cancelled sheet is not reported as an error', () async {
      when(
        applicationCubit.signInWithGoogle(),
      ).thenAnswer((_) async => const AuthOutcome.failure(AuthError.cancelled));
      final AuthCubit cubit = buildCubit();

      final bool isSuccess = await cubit.signInWithGoogle();

      expect(isSuccess, isFalse);
      expect(cubit.state.error, isNull);
      await cubit.close();
    });

    test('a real failure keeps its reason', () async {
      when(
        applicationCubit.signInWithGoogle(),
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
      clearInteractions(applicationCubit);

      await cubit.resendVerificationEmail();

      verifyNever(applicationCubit.sendVerificationEmail());
      await cubit.close();
    });

    test('sends again when no cooldown is active', () async {
      final AuthCubit cubit = buildCubit();

      await cubit.resendVerificationEmail();

      verify(applicationCubit.sendVerificationEmail()).called(1);
      expect(cubit.state.hasVerificationMailBeenSent, isTrue);
      expect(cubit.state.resendCooldown, AuthCubit.resendCooldownSeconds);
      await cubit.close();
    });

    test('reports a rate limit as an error', () async {
      when(applicationCubit.sendVerificationEmail()).thenAnswer(
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
        applicationCubit.refreshVerificationStatus(),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<bool> inFlight = cubit.checkVerification();
      // The verification succeeding tears down the widget that owns this
      // cubit, so it closes while the call is still running.
      await cubit.close();
      pending.complete(true);

      await expectLater(inFlight, completion(isTrue));
    });

    test('signIn does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        applicationCubit.signInWithEmail(any, any),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<bool> inFlight = cubit.signIn(
        email: 'player@example.com',
        password: 'sup3rSecret',
      );
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completion(isTrue));
    });

    test('register does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        applicationCubit.registerWithEmail(any, any),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<bool> inFlight = cubit.register(
        email: 'player@example.com',
        password: 'sup3rSecret',
        passwordRepeat: 'sup3rSecret',
      );
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completion(isTrue));
    });

    test('resendVerificationEmail does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        applicationCubit.sendVerificationEmail(),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<void> inFlight = cubit.resendVerificationEmail();
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completes);
    });

    test('signInWithGoogle does not emit after close', () async {
      final Completer<AuthOutcome> pending = Completer<AuthOutcome>();
      when(
        applicationCubit.signInWithGoogle(),
      ).thenAnswer((_) => pending.future);
      final AuthCubit cubit = buildCubit();

      final Future<bool> inFlight = cubit.signInWithGoogle();
      await cubit.close();
      pending.complete(const AuthOutcome.success());

      await expectLater(inFlight, completion(isTrue));
    });
  });

  group('AuthCubit.checkVerification', () {
    test('delegates to the application cubit', () async {
      final AuthCubit cubit = buildCubit();

      expect(await cubit.checkVerification(), isTrue);

      verify(applicationCubit.refreshVerificationStatus()).called(1);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('reports a still unverified address', () async {
      when(
        applicationCubit.refreshVerificationStatus(),
      ).thenAnswer((_) async => false);
      final AuthCubit cubit = buildCubit();

      expect(await cubit.checkVerification(), isFalse);
      await cubit.close();
    });
  });
}
