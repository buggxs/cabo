import 'package:cabo/domain/announcement/local_announcement_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalAnnouncementRepository', () {
    late LocalAnnouncementRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = LocalAnnouncementRepository();
    });

    test(
      'getLastSeenAnnouncementId returns null when nothing is stored',
      () async {
        expect(await repository.getLastSeenAnnouncementId(), isNull);
      },
    );

    test('saveLastSeenAnnouncementId persists and can be read back', () async {
      await repository.saveLastSeenAnnouncementId('summer-sale');

      expect(await repository.getLastSeenAnnouncementId(), 'summer-sale');
    });

    test('incrementAppStartCount counts up from 1', () async {
      expect(await repository.incrementAppStartCount(), 1);
      expect(await repository.incrementAppStartCount(), 2);
      expect(await repository.incrementAppStartCount(), 3);
    });
  });
}
