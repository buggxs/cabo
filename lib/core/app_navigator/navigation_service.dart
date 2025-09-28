import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> showAppDialog<T>({
    required Dialog Function(BuildContext context) dialog,
  }) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => dialog.call(context),
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
