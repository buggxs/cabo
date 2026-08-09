import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/settings/settings_screen.dart';
import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  static const Set<String> announcementRoutes = <String>{
    MainMenuScreen.route,
    GameHistoryScreen.route,
    AboutScreen.route,
    RuleSetScreen.route,
    SettingsScreen.route,
  };

  Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;

    switch (settings.name) {
      case MainMenuScreen.route:
        return MaterialPageRoute(builder: (_) => const MainMenuScreen());
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
          builder: (_) => StatisticsScreen(players: players, game: game),
        );

      case EndGameScreen.route:
        if (args is Map && args['game'] is Game) {
          return MaterialPageRoute(
            builder: (_) => EndGameScreen(game: args['game'] as Game),
          );
        }
        return _errorRoute();

      case GameHistoryScreen.route:
        return MaterialPageRoute(builder: (_) => const GameHistoryScreen());

      case AboutScreen.route:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      case RuleSetScreen.route:
        return MaterialPageRoute(builder: (_) => const RuleSetScreen());

      case SettingsScreen.route:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
