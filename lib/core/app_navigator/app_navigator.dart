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
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const MainMenuScreen(),
        );
      case StatisticsScreen.route:
        return _statisticsRoute(args);

      case EndGameScreen.route:
        if (args is Map && args['game'] is Game) {
          return MaterialPageRoute<dynamic>(
            builder: (BuildContext _) =>
                EndGameScreen(game: args['game'] as Game),
          );
        }
        return _errorRoute();

      case GameHistoryScreen.route:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const GameHistoryScreen(),
        );

      case AboutScreen.route:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const AboutScreen(),
        );

      case RuleSetScreen.route:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const RuleSetScreen(),
        );

      case SettingsScreen.route:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext _) => const SettingsScreen(),
        );

      default:
        return _errorRoute();
    }
  }

  Route<dynamic> _statisticsRoute(Object? args) {
    List<Player> players = <Player>[];
    Game? game;
    if (args is Map && args.containsKey('players')) {
      players = args['players'] as List<Player>;
    }
    if (args is Map && args.containsKey('game')) {
      game = args['game'] as Game?;
    }
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext _) =>
          StatisticsScreen(players: players, game: game),
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
