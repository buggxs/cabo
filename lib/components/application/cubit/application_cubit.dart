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
    required LocalApplicationRepository repository,
    required LocalDesignRepository designRepository,
    required AnnouncementCheckService announcementCheckService,
    required AuthService authService,
    required DeepLinkService deepLinkService,
  }) : _repository = repository,
       _designRepository = designRepository,
       _announcementCheckService = announcementCheckService,
       _authService = authService,
       _deepLinkService = deepLinkService,
       super(const ApplicationInitial()) {
    // userChanges instead of authStateChanges: only the former fires when
    // credentials are linked onto an anonymous user, which is the normal
    // case now that everybody is signed in from the start.
    _authSubscription = _authService.userChanges().listen((User? user) {
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

    unawaited(_authService.initializeProviders());
  }

  late final StreamSubscription<User?> _authSubscription;
  StreamSubscription<Uri>? _linkSubscription;
  final LocalApplicationRepository _repository;
  final LocalDesignRepository _designRepository;
  final AnnouncementCheckService _announcementCheckService;
  final AuthService _authService;
  final DeepLinkService _deepLinkService;

  // init() and the user stream can both resolve after close().
  void _safeEmit(ApplicationState next) {
    if (isClosed) return;
    emit(next);
  }

  Future<void> init() async {
    final bool isDeveloperMode = await _repository.getCurrent() ?? false;
    final AppDesign design = AppDesign.fromName(
      await _designRepository.getCurrent(),
    );
    CaboTheme.applyDesign(design);
    _safeEmit(state.copyWith(isDeveloper: isDeveloperMode, design: design));

    // Never awaited: a hanging sign-in must not delay the announcement, and
    // announcements are readable without auth anyway.
    unawaited(_authService.ensureSignedIn());
    unawaited(_announcementCheckService.checkAndShowAnnouncement());
    unawaited(_initDeepLinks());
  }

  void saveDesign(AppDesign design) {
    unawaited(_designRepository.saveCurrent(design.name));
    CaboTheme.applyDesign(design);
    _safeEmit(state.copyWith(design: design));
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // Every user stays signed in, so drop straight back to anonymous.
    await _authService.ensureSignedIn();
  }

  // The resulting state update comes from the userChanges subscription,
  // triggered by the forced token refresh.
  Future<void> refreshVerificationStatus() async {
    await _authService.refreshVerificationStatus();
  }

  void saveIsDeveloperMode({required bool isDeveloperMode}) {
    unawaited(_repository.saveCurrent(isDeveloperMode));
    _safeEmit(state.copyWith(isDeveloper: isDeveloperMode));
  }

  void toggleDeveloperMode() {
    final bool isDeveloperMode = !state.isDeveloper;
    saveIsDeveloperMode(isDeveloperMode: isDeveloperMode);
  }

  Future<void> _initDeepLinks() async {
    // Both paths are needed: getInitialLink covers the cold start, the stream
    // covers links arriving while the app runs. Handling one twice is safe.
    // Subscribe first: a link arriving while getInitialLink is in flight would
    // otherwise be dropped. Handling the same link twice is harmless.
    _linkSubscription = _deepLinkService.linkStream.listen(
      _handleLink,
      onError: (Object e) => logger.warning('Deep link stream error: $e'),
    );
    try {
      final Uri? initialLink = await _deepLinkService.getInitialLink();
      if (initialLink != null) {
        _handleLink(initialLink);
      }
    } on Exception catch (e, stackTrace) {
      logger.warning('Could not read the initial deep link', e, stackTrace);
    }
  }

  void _handleLink(Uri uri) {
    if (_deepLinkService.isEmailVerifiedLink(uri)) {
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
