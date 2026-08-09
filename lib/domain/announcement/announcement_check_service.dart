import 'package:cabo/common/presentation/widgets/announcement_dialog.dart';
import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/domain/announcement/announcement_repository.dart';
import 'package:cabo/domain/announcement/local_announcement_repository.dart';

/// Decides whether the announcement dialog should be shown on app start and,
/// if so, shows it and marks the announcement as seen.
class AnnouncementCheckService {
  AnnouncementCheckService({
    required this.announcementRepository,
    required this.localAnnouncementRepository,
    Future<void> Function(Announcement announcement)? showAnnouncementDialog,
  }) : _showAnnouncementDialog =
           showAnnouncementDialog ??
           ((Announcement announcement) =>
               AnnouncementDialog.show(announcement: announcement));

  final AnnouncementRepository announcementRepository;
  final LocalAnnouncementRepository localAnnouncementRepository;
  final Future<void> Function(Announcement announcement)
  _showAnnouncementDialog;

  /// Shows the announcement dialog once per new announcement, but never on
  /// the very first app start (new users should not see it immediately).
  Future<void> checkAndShowAnnouncement() async {
    final int appStartCount = await localAnnouncementRepository
        .incrementAppStartCount();
    if (appStartCount <= 1) {
      return;
    }

    final Announcement? announcement = await announcementRepository
        .getCurrentAnnouncement();
    if (announcement == null) {
      return;
    }

    final String? lastSeenId = await localAnnouncementRepository
        .getLastSeenAnnouncementId();
    if (lastSeenId == announcement.id) {
      return;
    }

    await _showAnnouncementDialog(announcement);
    await localAnnouncementRepository.saveLastSeenAnnouncementId(
      announcement.id,
    );
  }

  /// Shows the current announcement regardless of the seen-status or app
  /// start count. Used for previewing the dialog from developer settings.
  /// Returns `false` when no announcement is currently configured.
  Future<bool> forceShowAnnouncement() async {
    final Announcement? announcement = await announcementRepository
        .getCurrentAnnouncement();
    if (announcement == null) {
      return false;
    }

    await _showAnnouncementDialog(announcement);
    return true;
  }
}
