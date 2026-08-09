import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/domain/announcement/announcement_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'announcement_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(),
])
void main() {
  group('AnnouncementRepository', () {
    late MockFirebaseFirestore firestore;
    late MockCollectionReference collection;
    late MockDocumentReference document;
    late AnnouncementRepository repository;

    setUp(() {
      firestore = MockFirebaseFirestore();
      collection = MockCollectionReference();
      document = MockDocumentReference();
      when(firestore.collection('announcements')).thenReturn(collection);
      when(collection.doc('current')).thenReturn(document);
      repository = AnnouncementRepository(firestore: firestore);
    });

    test('returns the announcement when the document exists', () async {
      final MockDocumentSnapshot snapshot = MockDocumentSnapshot();
      when(snapshot.data()).thenReturn({
        'id': 'summer-sale',
        'title': {'de': 'Sommer-Angebot', 'en': 'Summer sale'},
        'message': {'de': 'Jetzt zuschlagen!', 'en': 'Grab it now!'},
        'imageUrl': null,
        'actions': [],
      });
      when(document.get()).thenAnswer((_) async => snapshot);

      final Announcement? result = await repository.getCurrentAnnouncement();

      expect(
        result,
        const Announcement(
          id: 'summer-sale',
          title: LocalizedText(de: 'Sommer-Angebot', en: 'Summer sale'),
          message: LocalizedText(de: 'Jetzt zuschlagen!', en: 'Grab it now!'),
          actions: [],
        ),
      );
    });

    test('returns null when the document does not exist', () async {
      final MockDocumentSnapshot snapshot = MockDocumentSnapshot();
      when(snapshot.data()).thenReturn(null);
      when(document.get()).thenAnswer((_) async => snapshot);

      final Announcement? result = await repository.getCurrentAnnouncement();

      expect(result, isNull);
    });

    test('returns null when Firestore throws', () async {
      when(
        document.get(),
      ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));

      final Announcement? result = await repository.getCurrentAnnouncement();

      expect(result, isNull);
    });
  });
}
