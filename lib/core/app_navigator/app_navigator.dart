import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
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
        Game? game;
        if (args is Map && args.containsKey('players')) {
          players = args['players'];
        }
        if (args is Map && args.containsKey('game')) {
          game = args['game'];
        }
        return MaterialPageRoute(
          builder: (_) => StatisticsScreen(
            players: players,
            game: game,
          ),
        );

      case GameHistoryScreen.route:
        return MaterialPageRoute(
          builder: (_) => const GameHistoryScreen(),
        );

      case AboutScreen.route:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
        );

      case RuleSetScreen.route:
        return MaterialPageRoute(
          builder: (_) => const RuleSetScreen(),
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
