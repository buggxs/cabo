import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GameStreak {
  const GameStreak({required this.message, required this.icon});

  final String message;
  final Icon icon;
}

enum GameStreakType {
  fiveRoundsWon,
  sevenRoundsWon,
  tenRoundsWon,
  oneHourGame,
  oneAndHalfHoursGame,
  twoHoursGame,
}

extension GameStreakTypeExtension on GameStreakType {
  GameStreak? get streak {
    final BuildContext context =
        app<NavigationService>().navigatorKey.currentContext!;

    switch (this) {
      case GameStreakType.fiveRoundsWon:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakFiveRoundsWon,
          icon: const Icon(
            Icons.local_fire_department_rounded, // Fire icon for streak
            color: Colors.orangeAccent, // Fiery color
            size: 18, // Slightly smaller icon inside border
          ),
        );
      case GameStreakType.sevenRoundsWon:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakSevenRoundsWon,
          icon: const Icon(
            Icons.local_fire_department_rounded, // Fire icon for streak
            color: Colors.deepOrangeAccent, // Fiery color
            size: 18, // Slightly smaller icon inside border
          ),
        );
      case GameStreakType.tenRoundsWon:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakTenRoundsWon,
          icon: const Icon(
            Icons.local_fire_department_rounded, // Fire icon for streak
            color: Colors.redAccent, // Fiery color
            size: 18, // Slightly smaller icon inside border
          ),
        );
      case GameStreakType.oneHourGame:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakOneHourGame,
          icon: const Icon(
            Icons.timer_outlined, // Timer icon for streak
            color: Colors.blueGrey,
            size: 18,
          ),
        );
      case GameStreakType.oneAndHalfHoursGame:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakOneAndHalfHourGame,
          icon: const Icon(
            Icons.timer_outlined, // Timer icon for streak
            color: Colors.lightBlueAccent,
            size: 18,
          ),
        );
      case GameStreakType.twoHoursGame:
        return GameStreak(
          message: AppLocalizations.of(context)!.streakTwoHourGame,
          icon: const Icon(
            Icons.timer_outlined, // Timer icon for streak
            color: Colors.blueAccent,
            size: 18,
          ),
        );
    }
  }
}
