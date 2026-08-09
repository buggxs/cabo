import 'package:cabo/domain/announcement/announcement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> announcementJson(List<Map<String, dynamic>>? actions) {
    return <String, dynamic>{
      'id': 'summer-sale',
      'title': {'de': 'Sommer-Angebot', 'en': 'Summer sale'},
      'message': {'de': 'Jetzt zuschlagen!', 'en': 'Grab it now!'},
      'imageUrl': null,
      'actions': actions,
    };
  }

  group('Announcement.fromJson', () {
    test('parses navigate and dismiss actions', () {
      final Announcement announcement = Announcement.fromJson(
        announcementJson(<Map<String, dynamic>>[
          {
            'type': 'navigate',
            'label': {'de': 'Zu den Regeln', 'en': 'To the rules'},
            'route': 'rule_set_screen',
          },
          {
            'type': 'dismiss',
            'label': {'de': 'Später', 'en': 'Later'},
          },
        ]),
      );

      expect(announcement.actions, <AnnouncementAction>[
        const AnnouncementAction(
          type: AnnouncementActionType.navigate,
          label: LocalizedText(de: 'Zu den Regeln', en: 'To the rules'),
          route: 'rule_set_screen',
        ),
        const AnnouncementAction(
          type: AnnouncementActionType.dismiss,
          label: LocalizedText(de: 'Später', en: 'Later'),
        ),
      ]);
    });

    test('falls back to dismiss for unknown and missing action types', () {
      final Announcement announcement = Announcement.fromJson(
        announcementJson(<Map<String, dynamic>>[
          {
            'type': 'open_url',
            'label': {'de': 'Öffnen', 'en': 'Open'},
          },
          {
            'label': {'de': 'Okay', 'en': 'Okay'},
          },
        ]),
      );

      expect(
        announcement.actions?.map((AnnouncementAction a) => a.type).toList(),
        <AnnouncementActionType>[
          AnnouncementActionType.dismiss,
          AnnouncementActionType.dismiss,
        ],
      );
    });

    test('keeps actions null when the field is missing', () {
      final Announcement announcement = Announcement.fromJson(
        announcementJson(null),
      );

      expect(announcement.actions, isNull);
    });
  });
}
