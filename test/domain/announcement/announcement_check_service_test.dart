import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/domain/announcement/announcement_check_service.dart';
import 'package:cabo/domain/announcement/announcement_repository.dart';
import 'package:cabo/domain/announcement/local_announcement_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'announcement_check_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnnouncementRepository>(),
  MockSpec<LocalAnnouncementRepository>(),
])
void main() {
  group('AnnouncementCheckService', () {
    const Announcement announcement = Announcement(
      id: 'summer-sale',
      title: LocalizedText(de: 'Sommer-Angebot', en: 'Summer sale'),
      message: LocalizedText(de: 'Jetzt zuschlagen!', en: 'Grab it now!'),
    );

    late MockAnnouncementRepository announcementRepository;
    late MockLocalAnnouncementRepository localAnnouncementRepository;
    late List<Announcement> shownAnnouncements;
    late AnnouncementCheckService service;

    setUp(() {
      announcementRepository = MockAnnouncementRepository();
      localAnnouncementRepository = MockLocalAnnouncementRepository();
      shownAnnouncements = [];

      service = AnnouncementCheckService(
        announcementRepository: announcementRepository,
        localAnnouncementRepository: localAnnouncementRepository,
        showAnnouncementDialog: (Announcement a) async {
          shownAnnouncements.add(a);
        },
      );
    });

    test(
      'shows the dialog for a new announcement on a later app start',
      () async {
        when(
          localAnnouncementRepository.incrementAppStartCount(),
        ).thenAnswer((_) async => 2);
        when(
          announcementRepository.getCurrentAnnouncement(),
        ).thenAnswer((_) async => announcement);
        when(
          localAnnouncementRepository.getLastSeenAnnouncementId(),
        ).thenAnswer((_) async => null);

        await service.checkAndShowAnnouncement();

        expect(shownAnnouncements, [announcement]);
        verify(
          localAnnouncementRepository.saveLastSeenAnnouncementId('summer-sale'),
        ).called(1);
      },
    );

    test(
      'does not show the dialog when the announcement was already seen',
      () async {
        when(
          localAnnouncementRepository.incrementAppStartCount(),
        ).thenAnswer((_) async => 2);
        when(
          announcementRepository.getCurrentAnnouncement(),
        ).thenAnswer((_) async => announcement);
        when(
          localAnnouncementRepository.getLastSeenAnnouncementId(),
        ).thenAnswer((_) async => 'summer-sale');

        await service.checkAndShowAnnouncement();

        expect(shownAnnouncements, isEmpty);
        verifyNever(
          localAnnouncementRepository.saveLastSeenAnnouncementId(any),
        );
      },
    );

    test(
      'does not show the dialog when loading the announcement fails',
      () async {
        when(
          localAnnouncementRepository.incrementAppStartCount(),
        ).thenAnswer((_) async => 2);
        when(
          announcementRepository.getCurrentAnnouncement(),
        ).thenAnswer((_) async => null);

        await service.checkAndShowAnnouncement();

        expect(shownAnnouncements, isEmpty);
        verifyNever(
          localAnnouncementRepository.saveLastSeenAnnouncementId(any),
        );
      },
    );

    test('does not show the dialog on the very first app start', () async {
      when(
        localAnnouncementRepository.incrementAppStartCount(),
      ).thenAnswer((_) async => 1);
      when(
        announcementRepository.getCurrentAnnouncement(),
      ).thenAnswer((_) async => announcement);
      when(
        localAnnouncementRepository.getLastSeenAnnouncementId(),
      ).thenAnswer((_) async => null);

      await service.checkAndShowAnnouncement();

      expect(shownAnnouncements, isEmpty);
      verifyNever(announcementRepository.getCurrentAnnouncement());
      verifyNever(localAnnouncementRepository.saveLastSeenAnnouncementId(any));
    });

    test(
      'forceShowAnnouncement shows the current announcement without touching seen-tracking',
      () async {
        when(
          announcementRepository.getCurrentAnnouncement(),
        ).thenAnswer((_) async => announcement);

        final bool wasShown = await service.forceShowAnnouncement();

        expect(wasShown, isTrue);
        expect(shownAnnouncements, [announcement]);
        verifyNever(localAnnouncementRepository.incrementAppStartCount());
        verifyNever(
          localAnnouncementRepository.saveLastSeenAnnouncementId(any),
        );
      },
    );

    test(
      'forceShowAnnouncement returns false when no announcement is configured',
      () async {
        when(
          announcementRepository.getCurrentAnnouncement(),
        ).thenAnswer((_) async => null);

        final bool wasShown = await service.forceShowAnnouncement();

        expect(wasShown, isFalse);
        expect(shownAnnouncements, isEmpty);
      },
    );
  });
}
