import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/end_game_card_shadow.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:flutter/material.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';

/// Per player: total points and three key figures (Cabo zero, penalty
/// points, average per round). The winner gets a coloured header.
class EndGameDetailedStatsCard extends StatelessWidget {
  const EndGameDetailedStatsCard({
    super.key,
    required this.player,
    required this.isWinner,
  });

  final Player player;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: endGameCardShadow,
      ),
      child: Column(
        children: <Widget>[
          _DetailedStatsHeader(player: player, isWinner: isWinner),
          _DetailedStatsRow(player: player),
        ],
      ),
    );
  }
}

class _DetailedStatsHeader extends StatelessWidget {
  const _DetailedStatsHeader({required this.player, required this.isWinner});

  final Player player;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    final Color headerBg = isWinner
        ? CaboTheme.primaryContainer
        : CaboTheme.surfaceVariant;
    final Color headerFg = isWinner
        ? CaboTheme.onPrimaryContainer
        : CaboTheme.onSurfaceVariant;

    return Container(
      color: headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CaboTheme.headlineMediumStyle.copyWith(color: headerFg),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                context.l10n.endGameStatTotal.toUpperCase(),
                style: CaboTheme.labelSmallStyle.copyWith(
                  color: headerFg.withValues(alpha: 0.8),
                ),
              ),
              Text(
                '${player.totalPoints} ${context.l10n.endGamePointsShort}',
                style: CaboTheme.headlineMediumStyle.copyWith(
                  color: headerFg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailedStatsRow extends StatelessWidget {
  const _DetailedStatsRow({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final int caboZero = player.rounds
        .where((Round round) => round.points == 0)
        .length;
    final int penaltyPoints =
        player.rounds.where((Round round) => round.hasPenaltyPoints).length *
        kFailedCaboPenaltyPoints;
    final int roundCount = player.rounds.length;
    final String average = roundCount == 0
        ? '0'
        : (player.totalPoints / roundCount).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildStatCell(
              value: '$caboZero',
              label: context.l10n.endGameStatCaboZero,
              valueColor: caboZero > 0
                  ? CaboTheme.m3Secondary
                  : CaboTheme.onSurface,
            ),
          ),
          Expanded(
            child: _buildStatCell(
              value: penaltyPoints > 0 ? '+$penaltyPoints' : '0',
              label: context.l10n.endGameStatPenalty,
              valueColor: penaltyPoints > 0
                  ? CaboTheme.m3Error
                  : CaboTheme.onSurface,
            ),
          ),
          Expanded(
            child: _buildStatCell(
              value: average,
              label: context.l10n.endGameStatAverage,
              valueColor: CaboTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: CaboTheme.headlineMediumStyle.copyWith(color: valueColor),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: CaboTheme.labelSmallStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
