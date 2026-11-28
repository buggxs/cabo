import 'dart:async';

import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:flutter/material.dart';

/// Single entry point for navigation. Works on the global navigator, so it can
/// be used without a [BuildContext], e.g. from cubits.
class NavigationService with LoggerMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => navigatorKey.currentState!;

  Future<T?> showAppDialog<T>({
    required Dialog Function(BuildContext context) dialog,
  }) {
    return showDialog<T>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => dialog.call(context),
    );
  }

  Future<T?> showAppModalBottomSheet<T>({required WidgetBuilder builder}) {
    return showModalBottomSheet<T>(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }

  void pop<T extends Object?>([T? result]) => _navigator.pop<T>(result);

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushFullscreenDialog<T extends Object?>(Widget screen) {
    return _navigator.push<T>(
      MaterialPageRoute<T>(
        builder: (BuildContext context) => screen,
        fullscreenDialog: true,
      ),
    );
  }

  void popAndPushNamed(String routeName, {Object? arguments}) {
    unawaited(
      _navigator.popAndPushNamed<void, void>(routeName, arguments: arguments),
    );
  }

  void pushNamedAndRemoveAll(String routeName) {
    unawaited(
      _navigator.pushNamedAndRemoveUntil<void>(
        routeName,
        (Route<dynamic> route) => false,
      ),
    );
  }

  bool pushAnnouncementRoute(String? routeName) {
    if (routeName == null ||
        !AppNavigator.announcementRoutes.contains(routeName)) {
      logger.severe(
        'Blocked announcement navigation to unknown route: $routeName',
      );
      return false;
    }

    unawaited(pushNamed<void>(routeName));
    return true;
  }

  void pushToEndGameScreen({required Game game}) {
    unawaited(
      _navigator.pushReplacementNamed<void, void>(
        EndGameScreen.route,
        arguments: <String, dynamic>{'game': game},
      ),
    );
  }

  void pushToStatsScreen({
    required List<Player> players,
    bool? shouldUseSpecialRules,
    Game? game,
  }) {
    popAndPushNamed(
      StatisticsScreen.route,
      arguments: <String, Object?>{
        'players': players,
        'shouldUseSpecialRules': shouldUseSpecialRules,
        'game': game,
      },
    );
  }
}
