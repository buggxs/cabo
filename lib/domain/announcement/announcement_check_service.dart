import 'package:cabo/common/presentation/widgets/announcement_dialog.dart';
import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/domain/announcement/announcement_repository.dart';
import 'package:cabo/domain/announcement/local_announcement_repository.dart';

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
