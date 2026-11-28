import 'dart:async';

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/about/widgets/debug_sample_games.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/announcement/announcement_check_service.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:flutter/material.dart';

/// Debug-only test area at the end of the about screen. Bundles buttons that
/// open specific areas/screens directly with synthetic data. Only included in
/// debug builds (`kDebugMode`).
class DebugTestSection extends StatelessWidget {
  const DebugTestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.m3Error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.bug_report_outlined,
                color: CaboTheme.m3Error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'DEBUG / TEST',
                style: CaboTheme.labelLargeStyle.copyWith(
                  color: CaboTheme.m3Error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DebugButton(
            label: 'Endscreen: fertiges Spiel (3 Spieler, 19 Runden)',
            icon: Icons.emoji_events_outlined,
            onPressed: _openFinishedGame,
          ),
          _DebugButton(
            label: 'Laufendes Spiel (4 Spieler, 15 Runden, alle Regelfälle)',
            icon: Icons.sports_esports_outlined,
            onPressed: _openRunningGame,
          ),
          _DebugButton(
            label: 'Game History mit Testdaten füllen (überschreibt)',
            icon: Icons.history,
            onPressed: () => _fillGameHistory(context),
          ),
          _DebugButton(
            label: 'Announcement-Dialog anzeigen',
            icon: Icons.campaign_outlined,
            onPressed: () => _showAnnouncement(context),
          ),
        ],
      ),
    );
  }

  void _openFinishedGame() {
    unawaited(
      app<NavigationService>().pushNamed<void>(
        EndGameScreen.route,
        arguments: <String, dynamic>{'game': DebugSampleGames.finishedGame()},
      ),
    );
  }

  // Closing another round overwrites the last played game.
  void _openRunningGame() {
    final Game game = DebugSampleGames.runningGame();

    unawaited(
      app<NavigationService>().pushNamed<void>(
        StatisticsScreen.route,
        arguments: <String, dynamic>{'players': game.players, 'game': game},
      ),
    );
  }

  Future<void> _showAnnouncement(BuildContext context) async {
    final bool wasShown = await app<AnnouncementCheckService>()
        .forceShowAnnouncement();

    if (!context.mounted || wasShown) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Es ist aktuell kein Announcement konfiguriert.'),
      ),
    );
  }

  // Overwrites the stored game history with synthetic finished games.
  Future<void> _fillGameHistory(BuildContext context) async {
    final List<Game> games = DebugSampleGames.historyGames();
    await app<GameService>().saveGames(games);

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game History gefüllt: ${games.length} Spiele')),
    );
    unawaited(
      app<NavigationService>().pushNamed<void>(GameHistoryScreen.route),
    );
  }
}

class _DebugButton extends StatelessWidget {
  const _DebugButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: CaboTheme.m3Error,
          alignment: Alignment.centerLeft,
          side: BorderSide(color: CaboTheme.m3Error.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          ),
        ),
        icon: Icon(icon, size: 18, color: CaboTheme.m3Error),
        label: Text(
          label,
          style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.m3Error),
        ),
      ),
    );
  }
}
