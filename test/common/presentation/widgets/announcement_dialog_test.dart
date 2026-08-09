import 'package:cabo/common/presentation/widgets/announcement_dialog.dart';
import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/components/settings/settings_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/announcement/announcement.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const LocalizedText title = LocalizedText(
    de: 'Sommer-Angebot',
    en: 'Summer sale',
  );
  const LocalizedText message = LocalizedText(
    de: 'Jetzt zuschlagen!',
    en: 'Grab it now!',
  );

  Announcement announcementWith(List<AnnouncementAction>? actions) {
    return Announcement(
      id: 'summer-sale',
      title: title,
      message: message,
      actions: actions,
    );
  }

  group('AnnouncementDialog', () {
    late NavigationService navigationService;
    late List<String?> pushedRoutes;

    setUp(() {
      navigationService = NavigationService();
      pushedRoutes = <String?>[];
      app.allowReassignment = true;
      app.registerSingleton<NavigationService>(navigationService);
    });

    tearDown(() => app.reset());

    Future<void> pumpDialog(
      WidgetTester tester,
      Announcement announcement, {
      Locale locale = const Locale('de'),
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          navigatorKey: navigationService.navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: <NavigatorObserver>[
            _RouteRecorder(pushedRoutes: pushedRoutes),
          ],
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => Scaffold(body: Text(settings.name ?? 'home')),
          ),
          home: Builder(
            builder: (BuildContext context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => Dialog(
                    child: AnnouncementDialog(announcement: announcement),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the default okay button without actions', (
      WidgetTester tester,
    ) async {
      await pumpDialog(tester, announcementWith(null));

      expect(find.text('Okay'), findsOneWidget);

      await tester.tap(find.text('Okay'));
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementDialog), findsNothing);
      expect(pushedRoutes, isNot(contains(SettingsScreen.route)));
    });

    testWidgets('shows the default okay button for an empty actions list', (
      WidgetTester tester,
    ) async {
      await pumpDialog(tester, announcementWith(<AnnouncementAction>[]));

      expect(find.text('Okay'), findsOneWidget);
    });

    testWidgets('navigates to a whitelisted route and closes the dialog', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.navigate,
            label: LocalizedText(de: 'Zu den Einstellungen', en: 'To settings'),
            route: SettingsScreen.route,
          ),
        ]),
      );

      await tester.tap(find.text('Zu den Einstellungen'));
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementDialog), findsNothing);
      expect(pushedRoutes, contains(SettingsScreen.route));
    });

    testWidgets('closes the dialog without navigating for an unknown route', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.navigate,
            label: LocalizedText(de: 'Los geht´s', en: 'Let us go'),
            route: 'evil_screen',
          ),
        ]),
      );

      await tester.tap(find.text('Los geht´s'));
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementDialog), findsNothing);
      expect(pushedRoutes, isNot(contains('evil_screen')));
    });

    testWidgets('closes the dialog without navigating for a missing route', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.navigate,
            label: LocalizedText(de: 'Weiter', en: 'Continue'),
          ),
        ]),
      );
      final int routeCountBefore = pushedRoutes.length;

      await tester.tap(find.text('Weiter'));
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementDialog), findsNothing);
      expect(pushedRoutes, hasLength(routeCountBefore));
    });

    testWidgets('closes the dialog without navigating for a dismiss action', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.dismiss,
            label: LocalizedText(de: 'Verstanden', en: 'Got it'),
            route: SettingsScreen.route,
          ),
        ]),
      );

      await tester.tap(find.text('Verstanden'));
      await tester.pumpAndSettle();

      expect(find.byType(AnnouncementDialog), findsNothing);
      expect(pushedRoutes, isNot(contains(SettingsScreen.route)));
    });

    testWidgets('renders at most two action buttons', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.navigate,
            label: LocalizedText(de: 'Erste', en: 'First'),
            route: SettingsScreen.route,
          ),
          const AnnouncementAction(
            type: AnnouncementActionType.dismiss,
            label: LocalizedText(de: 'Zweite', en: 'Second'),
          ),
          const AnnouncementAction(
            type: AnnouncementActionType.dismiss,
            label: LocalizedText(de: 'Dritte', en: 'Third'),
          ),
        ]),
      );

      expect(find.text('Erste'), findsOneWidget);
      expect(find.text('Zweite'), findsOneWidget);
      expect(find.text('Dritte'), findsNothing);
      expect(find.text('Okay'), findsNothing);
      expect(find.byType(CaboPrimaryButton), findsOneWidget);
    });

    testWidgets('uses the english action label for the english locale', (
      WidgetTester tester,
    ) async {
      await pumpDialog(
        tester,
        announcementWith(<AnnouncementAction>[
          const AnnouncementAction(
            type: AnnouncementActionType.dismiss,
            label: LocalizedText(de: 'Verstanden', en: 'Got it'),
          ),
        ]),
        locale: const Locale('en'),
      );

      expect(find.text('Got it'), findsOneWidget);
      expect(find.text('Verstanden'), findsNothing);
    });
  });
}

class _RouteRecorder extends NavigatorObserver {
  _RouteRecorder({required this.pushedRoutes});

  final List<String?> pushedRoutes;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route.settings.name);
  }
}
