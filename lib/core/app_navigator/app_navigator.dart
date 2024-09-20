import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/statistics/statistics_screen.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

    switch (settings.name) {
      case MainMenuScreen.route:
        return MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
        );
      case StatisticsScreen.route:
        List<Player> players = [];
        bool? shouldUseSpecialRules;
        Game? game;
        if (args is Map && args.containsKey('players')) {
          players = args['players'];
        }
        if (args is Map && args.containsKey('useOwnRuleSet')) {
          shouldUseSpecialRules = args['shouldUseSpecialRules'];
        }
        if (args is Map && args.containsKey('game')) {
          game = args['game'];
        }
        return MaterialPageRoute(
          builder: (_) => StatisticsScreen(
            players: players,
            shouldUseSpecialRules: shouldUseSpecialRules ?? false,
            game: game,
          ),
        );

      case GameHistoryScreen.route:
        return MaterialPageRoute(
          builder: (_) => const GameHistoryScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('ERROR'),
          ),
        );
      },
    );
  }
}
