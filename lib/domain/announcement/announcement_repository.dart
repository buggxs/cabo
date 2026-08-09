import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementRepository with LoggerMixin {
  AnnouncementRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Announcement?> getCurrentAnnouncement() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('announcements')
          .doc('current')
          .get();

      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) {
        return null;
      }

      return Announcement.fromJson(data);
    } catch (e, stackTrace) {
      logger.severe('Failed to load current announcement', e, stackTrace);
      return null;
    }
  }
}
