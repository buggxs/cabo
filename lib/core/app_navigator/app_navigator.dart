import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/statistics/statistics_screen.dart';
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
        return MaterialPageRoute(
          builder: (_) => const StatisticsScreen(),
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
