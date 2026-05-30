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
