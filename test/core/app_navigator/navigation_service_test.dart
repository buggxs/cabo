import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/settings/settings_screen.dart';
import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNavigator.announcementRoutes', () {
    test('contains only argument-less screen routes', () {
      expect(AppNavigator.announcementRoutes, <String>{
        MainMenuScreen.route,
        GameHistoryScreen.route,
        AboutScreen.route,
        RuleSetScreen.route,
        SettingsScreen.route,
      });
      expect(
        AppNavigator.announcementRoutes,
        isNot(contains(EndGameScreen.route)),
      );
    });
  });

  group('NavigationService.pushAnnouncementRoute', () {
    late NavigationService service;
    late List<String?> pushedRoutes;

    Future<void> pumpApp(WidgetTester tester) {
      return tester.pumpWidget(
        MaterialApp(
          navigatorKey: service.navigatorKey,
          navigatorObservers: <NavigatorObserver>[
            _RouteRecorder(pushedRoutes: pushedRoutes),
          ],
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => Scaffold(body: Text(settings.name ?? 'home')),
          ),
          home: const Scaffold(),
        ),
      );
    }

    setUp(() {
      service = NavigationService();
      pushedRoutes = <String?>[];
    });

    testWidgets('navigates to a whitelisted route', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      final bool hasNavigated = service.pushAnnouncementRoute(
        SettingsScreen.route,
      );
      await tester.pumpAndSettle();

      expect(hasNavigated, isTrue);
      expect(pushedRoutes, contains(SettingsScreen.route));
    });

    testWidgets('does not navigate to an unknown route', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      final bool hasNavigated = service.pushAnnouncementRoute('evil_screen');
      await tester.pumpAndSettle();

      expect(hasNavigated, isFalse);
      expect(pushedRoutes, isNot(contains('evil_screen')));
    });

    testWidgets('does not navigate to a route requiring arguments', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      final bool hasNavigated = service.pushAnnouncementRoute(
        EndGameScreen.route,
      );
      await tester.pumpAndSettle();

      expect(hasNavigated, isFalse);
      expect(pushedRoutes, isNot(contains(EndGameScreen.route)));
    });

    testWidgets('does not navigate when no route is given', (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      final int routeCountBefore = pushedRoutes.length;

      final bool hasNavigated = service.pushAnnouncementRoute(null);
      await tester.pumpAndSettle();

      expect(hasNavigated, isFalse);
      expect(pushedRoutes, hasLength(routeCountBefore));
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
