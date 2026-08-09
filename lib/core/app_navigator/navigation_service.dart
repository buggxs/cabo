import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/core/app_navigator/app_navigator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:flutter/material.dart';

class NavigationService with LoggerMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> showAppDialog<T>({
    required Dialog Function(BuildContext context) dialog,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => dialog.call(context),
    );
  }

  /// Zeigt ein modales Bottom-Sheet (neues helles Design) über dem globalen
  /// Navigator. Das Sheet darf die volle Höhe nutzen ([isScrollControlled]).
  Future<T?> showAppModalBottomSheet<T>({required WidgetBuilder builder}) {
    return showModalBottomSheet<T>(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: builder,
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

    Navigator.of(navigatorKey.currentContext!).pushNamed(routeName);
    return true;
  }

  /// Ersetzt den aktiven Stats-Screen durch den [EndGameScreen]. Wird vom Cubit
  /// (ohne BuildContext) genutzt, sobald ein Spiel beendet ist.
  void pushToEndGameScreen({required Game game}) {
    Navigator.of(navigatorKey.currentContext!).pushReplacementNamed(
      EndGameScreen.route,
      arguments: <String, dynamic>{'game': game},
    );
  }

  void pushToStatsScreen({
    required List<Player> players,
    bool? shouldUseSpecialRules,
    Game? game,
  }) {
    Navigator.of(navigatorKey.currentContext!).popAndPushNamed(
      StatisticsScreen.route,
      arguments: {
        'players': players,
        'shouldUseSpecialRules': shouldUseSpecialRules,
        'game': game,
      },
    );
  }
}
