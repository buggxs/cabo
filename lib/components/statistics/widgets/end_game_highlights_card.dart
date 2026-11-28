import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/end_game_card_shadow.dart';
import 'package:cabo/components/statistics/widgets/end_game_highlight_row.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Score-pad styled card with the best round (lowest total), the longest win
/// streak and the game streak milestones.
class EndGameHighlightsCard extends StatelessWidget {
  const EndGameHighlightsCard({
    super.key,
    required this.game,
    required this.rankedPlayers,
  });

  final Game game;
  final List<Player> rankedPlayers;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = _buildRows(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CaboTheme.background,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: endGameCardShadow,
      ),
      child: Column(
        children: <Widget>[
          _buildTitle(context),
          const SizedBox(height: 16),
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            rows[i],
            if (i != rows.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: CaboTheme.outlineVariant)),
      ),
      width: double.infinity,
      child: Text(
        context.l10n.endGameHighlightsTitle.toUpperCase(),
        textAlign: TextAlign.center,
        style: CaboTheme.labelLargeStyle.copyWith(color: CaboTheme.m3Primary),
      ),
    );
  }

  List<Widget> _buildRows(BuildContext context) {
    final Widget? bestRound = _buildBestRoundHighlight(context);
    final Widget? longestStreak = _buildLongestStreakHighlight(context);

    return <Widget>[
      ?bestRound,
      ?longestStreak,
      ...game.getGameStreakTypes().map(
        (GameStreakType type) => _buildGameStreakHighlight(context, type),
      ),
    ];
  }

  // The round with the lowest total points across all players.
  Widget? _buildBestRoundHighlight(BuildContext context) {
    final int roundCount = rankedPlayers
        .map((Player p) => p.rounds.length)
        .fold(0, (int a, int b) => a > b ? a : b);
    if (roundCount == 0) {
      return null;
    }

    int? bestRoundIndex;
    int bestTotal = 0;
    for (int i = 0; i < roundCount; i++) {
      int total = 0;
      for (final Player player in rankedPlayers) {
        if (i < player.rounds.length) {
          total += player.rounds[i].points;
        }
      }
      if (bestRoundIndex == null || total < bestTotal) {
        bestRoundIndex = i;
        bestTotal = total;
      }
    }

    return EndGameHighlightRow(
      icon: Icons.military_tech,
      iconBg: CaboTheme.secondaryContainer,
      iconFg: CaboTheme.onSecondaryContainer,
      title: context.l10n.endGameHighlightBestRound,
      subtitle:
          '$bestTotal ${context.l10n.endGamePointsShort} '
          '${context.l10n.endGameHighlightTotalSuffix} — '
          '${context.l10n.endGameRoundLabel} ${bestRoundIndex! + 1}',
    );
  }

  // Only shown for a streak of at least two rounds in a row.
  Widget? _buildLongestStreakHighlight(BuildContext context) {
    Player? best;
    int bestStreak = 0;
    for (final Player player in rankedPlayers) {
      final int streak = player.longestRoundWinStreak;
      if (streak > bestStreak) {
        bestStreak = streak;
        best = player;
      }
    }

    if (best == null || bestStreak < 2) {
      return null;
    }

    return EndGameHighlightRow(
      icon: Icons.local_fire_department_rounded,
      iconBg: CaboTheme.tertiaryFixed,
      iconFg: CaboTheme.m3Tertiary,
      title: context.l10n.endGameHighlightLongestStreak,
      subtitle:
          '${best.name} — '
          '${context.l10n.endGameHighlightStreakRounds(bestStreak)}',
    );
  }

  // Win streak milestones (5/7/10) and game duration milestones (1/1.5/2 h).
  Widget _buildGameStreakHighlight(BuildContext context, GameStreakType type) {
    final String subtitle = switch (type) {
      GameStreakType.fiveRoundsWon => context.l10n.streakFiveRoundsWon,
      GameStreakType.sevenRoundsWon => context.l10n.streakSevenRoundsWon,
      GameStreakType.tenRoundsWon => context.l10n.streakTenRoundsWon,
      GameStreakType.oneHourGame => context.l10n.streakOneHourGame,
      GameStreakType.oneAndHalfHoursGame =>
        context.l10n.streakOneAndHalfHourGame,
      GameStreakType.twoHoursGame => context.l10n.streakTwoHourGame,
    };

    if (_isWinStreak(type)) {
      return EndGameHighlightRow(
        icon: Icons.local_fire_department_rounded,
        iconBg: CaboTheme.primaryFixedDim.withValues(alpha: 0.3),
        iconFg: CaboTheme.m3Primary,
        title: context.l10n.endGameStreakWinTitle,
        subtitle: subtitle,
      );
    }

    return EndGameHighlightRow(
      icon: Icons.timer_outlined,
      iconBg: CaboTheme.surfaceContainerHighest,
      iconFg: CaboTheme.onSurfaceVariant,
      title: context.l10n.endGameStreakDurationTitle,
      subtitle: subtitle,
    );
  }

  bool _isWinStreak(GameStreakType type) {
    return type == GameStreakType.fiveRoundsWon ||
        type == GameStreakType.sevenRoundsWon ||
        type == GameStreakType.tenRoundsWon;
  }
}
