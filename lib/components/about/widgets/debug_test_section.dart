import 'dart:math';

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:flutter/material.dart';

/// Debug-only Testbereich am Ende des About-Screens. Bündelt Buttons, mit denen
/// sich bestimmte Bereiche/Screens mit synthetischen Daten direkt aufrufen
/// lassen. Wird ausschließlich im Debug-Build (`kDebugMode`) eingebunden.
class DebugTestSection extends StatelessWidget {
  const DebugTestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(
          color: CaboTheme.m3Error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
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
            onPressed: () => Navigator.of(context).pushNamed(
              EndGameScreen.route,
              arguments: <String, dynamic>{'game': _buildSampleFinishedGame()},
            ),
          ),
        ],
      ),
    );
  }

  /// Baut ein deterministisch erzeugtes, abgeschlossenes Spiel mit 3 Spielern
  /// und je 19 Runden. Der Spieler mit den meisten Punkten überschreitet sicher
  /// `totalGamePoints` (Default 100), sodass das Spiel als beendet gilt.
  Game _buildSampleFinishedGame() {
    const RuleSet ruleSet = RuleSet();
    final Random rng = Random(42);

    List<Round> buildRounds(int base, int range) {
      return List<Round>.generate(19, (int i) {
        final int points = base + rng.nextInt(range);
        // Jede 6. Runde als Straf-Runde markieren, damit die Detailwerte
        // auch Straf-Punkte zur Anzeige bringen.
        final bool hasPenalty = points > 0 && i % 6 == 0;
        return Round(
          round: i + 1,
          points: points,
          isWonRound: points == 0,
          hasClosedRound: points == 0,
          hasPenaltyPoints: hasPenalty,
        );
      });
    }

    // base/range so gewählt, dass „Lena" garantiert über 100 Punkte landet.
    List<Player> players = <Player>[
      Player(name: 'Mia', rounds: buildRounds(0, 5)),
      Player(name: 'Tom', rounds: buildRounds(2, 7)),
      Player(name: 'Lena', rounds: buildRounds(6, 7)),
    ];

    // Aufsteigend nach Punkten sortieren und Platzierung setzen (analog Cubit).
    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    return Game(
      startedAt: '01-01-2026 18:00',
      finishedAt: '01-01-2026 19:30',
      players: players,
      ruleSet: ruleSet,
    );
  }
}

/// Einheitlicher Button-Stil für den Debug-Bereich (untereinander aufgereiht).
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
