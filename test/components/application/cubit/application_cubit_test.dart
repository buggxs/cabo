import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/domain/announcement/announcement_check_service.dart';
import 'package:cabo/domain/application/app_design.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/domain/application/deep_link_service.dart';
import 'package:cabo/domain/application/local_application_repository.dart';
import 'package:cabo/domain/application/local_design_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'application_cubit_test.mocks.dart';

@GenerateNiceMocks(<MockSpec<dynamic>>[
  MockSpec<AuthService>(),
  MockSpec<DeepLinkService>(),
  MockSpec<LocalApplicationRepository>(),
  MockSpec<LocalDesignRepository>(),
  MockSpec<AnnouncementCheckService>(),
  MockSpec<User>(),
])
void main() {
  late MockAuthService authService;
  late MockDeepLinkService deepLinkService;
  late MockLocalApplicationRepository repository;
  late MockLocalDesignRepository designRepository;
  late MockAnnouncementCheckService announcementCheckService;
  late StreamController<User?> userController;
  late StreamController<Uri> linkController;

  setUp(() {
    authService = MockAuthService();
    deepLinkService = MockDeepLinkService();
    repository = MockLocalApplicationRepository();
    designRepository = MockLocalDesignRepository();
    announcementCheckService = MockAnnouncementCheckService();
    userController = StreamController<User?>.broadcast();
    linkController = StreamController<Uri>.broadcast();

    when(authService.userChanges()).thenAnswer((_) => userController.stream);
    when(authService.initializeProviders()).thenAnswer((_) async {});
    when(
      authService.ensureSignedIn(),
    ).thenAnswer((_) async => const AuthOutcome.success());
    when(authService.refreshVerificationStatus()).thenAnswer((_) async => true);
    when(deepLinkService.linkStream).thenAnswer((_) => linkController.stream);
    when(deepLinkService.getInitialLink()).thenAnswer((_) async => null);
    when(deepLinkService.isEmailVerifiedLink(any)).thenAnswer(
      (Invocation i) =>
          DeepLinkService().isEmailVerifiedLink(i.positionalArguments.first),
    );
    when(repository.getCurrent()).thenAnswer((_) async => false);
    when(designRepository.getCurrent()).thenAnswer((_) async => 'modern');
    when(
      announcementCheckService.checkAndShowAnnouncement(),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    userController.close();
    linkController.close();
  });

  ApplicationCubit buildCubit() => ApplicationCubit(
    repository: repository,
    designRepository: designRepository,
    announcementCheckService: announcementCheckService,
    authService: authService,
    deepLinkService: deepLinkService,
  );

  MockUser buildUser({
    String uid = 'uid-1',
    bool isAnonymous = false,
    bool isEmailVerified = false,
    String? email = 'player@example.com',
  }) {
    final MockUser user = MockUser();
    when(user.uid).thenReturn(uid);
    when(user.isAnonymous).thenReturn(isAnonymous);
    when(user.emailVerified).thenReturn(isEmailVerified);
    when(user.email).thenReturn(email);
    return user;
  }

  group('ApplicationCubit.init', () {
    test('signs the user in anonymously without any interaction', () async {
      final ApplicationCubit cubit = buildCubit();

      cubit.init();
      await Future<void>.delayed(Duration.zero);

      verify(authService.ensureSignedIn()).called(1);
      await cubit.close();
    });

    test('still shows the announcement when signing in fails', () async {
      when(
        authService.ensureSignedIn(),
      ).thenAnswer((_) async => const AuthOutcome.failure(AuthError.network));
      final ApplicationCubit cubit = buildCubit();

      cubit.init();
      await Future<void>.delayed(Duration.zero);

      verify(announcementCheckService.checkAndShowAnnouncement()).called(1);
      await cubit.close();
    });
  });

  group('ApplicationCubit auth state', () {
    blocTest<ApplicationCubit, ApplicationState>(
      'an anonymous user may not publish a game',
      build: buildCubit,
      act: (ApplicationCubit cubit) async {
        userController.add(buildUser(isAnonymous: true, email: null));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (ApplicationCubit cubit) {
        expect(cubit.state.isSignedIn, isTrue);
        expect(cubit.state.isAnonymous, isTrue);
        expect(cubit.state.hasAccount, isFalse);
        expect(cubit.state.canPublishGame, isFalse);
        expect(cubit.state.isAwaitingEmailVerification, isFalse);
      },
    );

    blocTest<ApplicationCubit, ApplicationState>(
      'an unverified account is awaiting verification',
      build: buildCubit,
      act: (ApplicationCubit cubit) async {
        userController.add(buildUser());
        await Future<void>.delayed(Duration.zero);
      },
      verify: (ApplicationCubit cubit) {
        expect(cubit.state.hasAccount, isTrue);
        expect(cubit.state.canPublishGame, isFalse);
        expect(cubit.state.isAwaitingEmailVerification, isTrue);
      },
    );

    blocTest<ApplicationCubit, ApplicationState>(
      'a verified account may publish a game',
      build: buildCubit,
      act: (ApplicationCubit cubit) async {
        userController.add(buildUser(isEmailVerified: true));
        await Future<void>.delayed(Duration.zero);
      },
      verify: (ApplicationCubit cubit) {
        expect(cubit.state.canPublishGame, isTrue);
        expect(cubit.state.isAwaitingEmailVerification, isFalse);
      },
    );

    blocTest<ApplicationCubit, ApplicationState>(
      'a signed out user is unauthenticated',
      build: buildCubit,
      act: (ApplicationCubit cubit) async {
        userController.add(null);
        await Future<void>.delayed(Duration.zero);
      },
      verify: (ApplicationCubit cubit) {
        expect(cubit.state, isA<ApplicationUnauthenticated>());
        expect(cubit.state.canPublishGame, isFalse);
      },
    );

    test(
      'emits a new state when emailVerified flips on the same user',
      () async {
        // Regression guard: User is mutable and has no value equality, so
        // putting it into props would make Equatable swallow this change.
        final MockUser user = MockUser();
        bool isVerified = false;
        when(user.uid).thenReturn('uid-1');
        when(user.isAnonymous).thenReturn(false);
        when(user.email).thenReturn('player@example.com');
        when(user.emailVerified).thenAnswer((_) => isVerified);

        final ApplicationCubit cubit = buildCubit();
        final List<bool> observed = <bool>[];
        final StreamSubscription<ApplicationState> sub = cubit.stream.listen(
          (ApplicationState state) => observed.add(state.canPublishGame),
        );

        userController.add(user);
        await Future<void>.delayed(Duration.zero);
        isVerified = true;
        userController.add(user);
        await Future<void>.delayed(Duration.zero);

        expect(observed, <bool>[false, true]);
        await sub.cancel();
        await cubit.close();
      },
    );
  });

  group('ApplicationCubit deep links', () {
    test('refreshes the status for the verification link', () async {
      final ApplicationCubit cubit = buildCubit();
      cubit.init();
      await Future<void>.delayed(Duration.zero);

      linkController.add(Uri.parse('https://www.buggxs.com/cabo/verified'));
      await Future<void>.delayed(Duration.zero);

      verify(authService.refreshVerificationStatus()).called(1);
      await cubit.close();
    });

    test('ignores unrelated links', () async {
      final ApplicationCubit cubit = buildCubit();
      cubit.init();
      await Future<void>.delayed(Duration.zero);

      linkController.add(Uri.parse('https://www.buggxs.com/projects/cabo-v2'));
      await Future<void>.delayed(Duration.zero);

      verifyNever(authService.refreshVerificationStatus());
      await cubit.close();
    });

    test('handles a verification link from a cold start', () async {
      when(deepLinkService.getInitialLink()).thenAnswer(
        (_) async => Uri.parse('https://www.buggxs.com/cabo/verified'),
      );
      final ApplicationCubit cubit = buildCubit();

      cubit.init();
      await Future<void>.delayed(Duration.zero);

      verify(authService.refreshVerificationStatus()).called(1);
      await cubit.close();
    });
  });

  group('ApplicationCubit.signOut', () {
    test('drops straight back to an anonymous session', () async {
      final ApplicationCubit cubit = buildCubit();

      await cubit.signOut();

      verify(authService.signOut()).called(1);
      verify(authService.ensureSignedIn()).called(1);
      await cubit.close();
    });
  });

  group('ApplicationCubit startup ordering', () {
    test(
      'an auth event during init does not reset design or dev mode',
      () async {
        // init() emits onto whatever state the user stream produced first, so a
        // late auth event must carry isDeveloper and design forward.
        when(repository.getCurrent()).thenAnswer((_) async => true);
        when(designRepository.getCurrent()).thenAnswer((_) async => 'classic');
        final ApplicationCubit cubit = buildCubit();

        cubit.init();
        await Future<void>.delayed(Duration.zero);
        userController.add(buildUser(isAnonymous: true, email: null));
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.isDeveloper, isTrue);
        expect(cubit.state.design, AppDesign.fromName('classic'));
        expect(cubit.state.isSignedIn, isTrue);
        await cubit.close();
      },
    );

    test(
      'an auth event before init finishes keeps the loaded settings',
      () async {
        when(repository.getCurrent()).thenAnswer((_) async => true);
        when(designRepository.getCurrent()).thenAnswer((_) async => 'classic');
        final ApplicationCubit cubit = buildCubit();

        userController.add(buildUser(isAnonymous: true, email: null));
        cubit.init();
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.isDeveloper, isTrue);
        expect(cubit.state.design, AppDesign.fromName('classic'));
        await cubit.close();
      },
    );
  });

  group('ApplicationCubit.signOut failure', () {
    test('a failing re-sign-in leaves the app usable', () async {
      final ApplicationCubit cubit = buildCubit();
      when(
        authService.ensureSignedIn(),
      ).thenAnswer((_) async => const AuthOutcome.failure(AuthError.network));

      await expectLater(cubit.signOut(), completes);

      verify(authService.signOut()).called(1);
      verify(authService.ensureSignedIn()).called(1);
      await cubit.close();
    });
  });

  group('ApplicationCubit.init design', () {
    test('applies the stored design and developer flag', () async {
      when(repository.getCurrent()).thenAnswer((_) async => true);
      when(designRepository.getCurrent()).thenAnswer((_) async => 'classic');
      final ApplicationCubit cubit = buildCubit();

      cubit.init();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isDeveloper, isTrue);
      expect(cubit.state.design, AppDesign.fromName('classic'));
      await cubit.close();
    });
  });
}
