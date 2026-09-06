import 'dart:async';

import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/auth/widgets/auth_form.dart';
import 'package:cabo/domain/application/app_design.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_form_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[MockSpec<ApplicationCubit>()])
void main() {
  late MockApplicationCubit applicationCubit;
  late StreamController<ApplicationState> stateController;

  setUp(() {
    applicationCubit = MockApplicationCubit();
    stateController = StreamController<ApplicationState>.broadcast();
    when(applicationCubit.stream).thenAnswer((_) => stateController.stream);
    when(
      applicationCubit.sendVerificationEmail(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(
      applicationCubit.refreshVerificationStatus(),
    ).thenAnswer((_) async => false);
  });

  tearDown(() => stateController.close());

  void setState(ApplicationState state) {
    when(applicationCubit.state).thenReturn(state);
  }

  Future<void> pump(WidgetTester tester) async {
    // Tall enough that the scrollable form fits: otherwise the buttons sit
    // outside the viewport and taps land on nothing.
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: BlocProvider<ApplicationCubit>.value(
            value: applicationCubit,
            child: const AuthForm(),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('AuthForm', () {
    testWidgets('offers the providers to an anonymous user', (
      WidgetTester tester,
    ) async {
      setState(const ApplicationUnauthenticated());

      await pump(tester);

      expect(find.text('Log in with Google'), findsOneWidget);
      expect(find.text('Log in/register with e-mail'), findsOneWidget);
      expect(find.text('Confirm your e-mail'), findsNothing);
    });

    testWidgets('shows the verification notice for an unverified account', (
      WidgetTester tester,
    ) async {
      setState(_FakeAccountState(isEmailVerified: false));

      await pump(tester);

      expect(find.text('Confirm your e-mail'), findsOneWidget);
      expect(find.text('I have confirmed'), findsOneWidget);
      expect(find.text('Log in with Google'), findsNothing);
    });

    testWidgets('points at the spam folder while awaiting confirmation', (
      WidgetTester tester,
    ) async {
      // The sending domain is new, so mails do land in spam -- the hint has to
      // be visible, not a footnote.
      setState(_FakeAccountState(isEmailVerified: false));

      await pump(tester);

      expect(
        find.textContaining('spam folder', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('a failed sign-in shows the reason', (
      WidgetTester tester,
    ) async {
      setState(const ApplicationUnauthenticated());
      when(applicationCubit.signInWithEmail(any, any)).thenAnswer(
        (_) async => const AuthOutcome.failure(AuthError.invalidCredentials),
      );

      await pump(tester);
      await tester.tap(find.text('Log in/register with e-mail'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'player@example.com',
      );
      await tester.enterText(find.byType(TextField).last, 'sup3rSecret');
      await tester.tap(find.text('Log in'));
      await tester.pump();

      // Regression guard: the form used to swallow every form level error, so
      // a wrong password looked like nothing happened at all.
      expect(find.text('E-mail or password is wrong.'), findsOneWidget);
    });

    testWidgets('a mistyped e-mail is reported on the field', (
      WidgetTester tester,
    ) async {
      setState(const ApplicationUnauthenticated());

      await pump(tester);
      await tester.tap(find.text('Log in/register with e-mail'));
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, 'not-an-email');
      await tester.enterText(find.byType(TextField).last, 'sup3rSecret');
      await tester.tap(find.text('Log in'));
      await tester.pump();

      expect(find.text('Please enter a valid e-mail address.'), findsOneWidget);
      verifyNever(applicationCubit.signInWithEmail(any, any));
    });
  });
}

/// A signed in, non-anonymous account. Built by hand because
/// ApplicationAuthenticated reads its values off a real Firebase User.
class _FakeAccountState extends ApplicationState {
  const _FakeAccountState({required this.isEmailVerified});

  @override
  final bool isEmailVerified;

  @override
  bool get isSignedIn => true;

  @override
  bool get isAnonymous => false;

  @override
  String? get email => 'player@example.com';

  @override
  User? get user => null;

  @override
  ApplicationState copyWith({bool? isDeveloper, AppDesign? design}) => this;
}
