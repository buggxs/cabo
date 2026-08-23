import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/domain/announcement/announcement_check_service.dart';
import 'package:cabo/domain/application/app_design.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/domain/application/deep_link_service.dart';
import 'package:cabo/domain/application/local_application_repository.dart';
import 'package:cabo/domain/application/local_design_repository.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> with LoggerMixin {
  ApplicationCubit({
    required this.repository,
    required this.designRepository,
    required this.announcementCheckService,
    required this.authService,
    required this.deepLinkService,
  }) : super(const ApplicationInitial()) {
    // userChanges instead of authStateChanges: only the former fires when
    // credentials are linked onto an anonymous user, which is the normal
    // case now that everybody is signed in from the start.
    _authSubscription = authService.userChanges().listen((User? user) {
      if (user == null) {
        _safeEmit(
          ApplicationUnauthenticated(
            isDeveloper: state.isDeveloper,
            design: state.design,
          ),
        );
      } else {
        _safeEmit(
          ApplicationAuthenticated(
            user: user,
            isDeveloper: state.isDeveloper,
            design: state.design,
          ),
        );
      }
    });

    unawaited(authService.initializeProviders());
  }

  late final StreamSubscription<User?> _authSubscription;
  StreamSubscription<Uri>? _linkSubscription;
  final LocalApplicationRepository repository;
  final LocalDesignRepository designRepository;
  final AnnouncementCheckService announcementCheckService;
  final AuthService authService;
  final DeepLinkService deepLinkService;

  /// Emits only while the cubit is alive: init() and the user stream can both
  /// resolve after close().
  void _safeEmit(ApplicationState next) {
    if (isClosed) return;
    emit(next);
  }

  void init() async {
    final isDeveloperMode = await repository.getCurrent() ?? false;
    final AppDesign design = AppDesign.fromName(
      await designRepository.getCurrent(),
    );
    CaboTheme.applyDesign(design);
    _safeEmit(state.copyWith(isDeveloper: isDeveloperMode, design: design));

    // Never awaited: a hanging sign-in must not delay the announcement, and
    // announcements are readable without auth anyway.
    unawaited(authService.ensureSignedIn());
    unawaited(announcementCheckService.checkAndShowAnnouncement());
    unawaited(_initDeepLinks());
  }

  void saveDesign(AppDesign design) {
    designRepository.saveCurrent(design.name);
    CaboTheme.applyDesign(design);
    _safeEmit(state.copyWith(design: design));
  }

  Future<void> signOut() async {
    await authService.signOut();
    // Every user stays signed in, so drop straight back to anonymous.
    await authService.ensureSignedIn();
  }

  Future<void> signInAnonymously() async {
    await authService.ensureSignedIn();
  }

  Future<bool> signInWithGoogle() async {
    final AuthOutcome outcome = await authService.signInWithGoogle();
    return outcome.isSuccess;
  }

  Future<AuthOutcome> registerWithEmail(String email, String password) {
    return authService.registerWithEmail(email: email, password: password);
  }

  Future<AuthOutcome> signInWithEmail(String email, String password) {
    return authService.signInWithEmail(email: email, password: password);
  }

  Future<AuthOutcome> sendVerificationEmail() {
    return authService.sendVerificationEmail();
  }

  /// Re-reads the verification status. The resulting state update comes from
  /// the userChanges subscription, triggered by the forced token refresh.
  Future<bool> refreshVerificationStatus() {
    return authService.refreshVerificationStatus();
  }

  void saveIsDeveloperMode(bool isDeveloperMode) {
    repository.saveCurrent(isDeveloperMode);
    _safeEmit(state.copyWith(isDeveloper: isDeveloperMode));
  }

  void toggleDeveloperMode() {
    final bool newMode = !state.isDeveloper;
    saveIsDeveloperMode(newMode);
  }

  Future<void> _initDeepLinks() async {
    // Both paths are needed: getInitialLink covers the cold start, the stream
    // covers links arriving while the app runs. Handling one twice is safe.
    try {
      final Uri? initialLink = await deepLinkService.getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } catch (e, stackTrace) {
      logger.warning('Could not read the initial deep link', e, stackTrace);
    }
    _linkSubscription = deepLinkService.linkStream.listen(
      _handleLink,
      onError: (Object e) => logger.warning('Deep link stream error: $e'),
    );
  }

  void _handleLink(Uri uri) {
    if (deepLinkService.isEmailVerifiedLink(uri)) {
      unawaited(refreshVerificationStatus());
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await _linkSubscription?.cancel();
    return super.close();
  }
}
