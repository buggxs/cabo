import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/end_game_card_shadow.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Final ranking of all players with place badge, name and total points.
class EndGameRankingCard extends StatelessWidget {
  const EndGameRankingCard({super.key, required this.rankedPlayers});

  final List<Player> rankedPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: endGameCardShadow,
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rankedPlayers.length; i++)
            _RankRow(
              player: rankedPlayers[i],
              isLast: i == rankedPlayers.length - 1,
            ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.player, required this.isLast});

  final Player player;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final int place = player.place ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: CaboTheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
      ),
      child: Row(
        children: <Widget>[
          _PlaceBadge(place: place),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: CaboTheme.onSurface,
                fontWeight: place == 1 ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${player.totalPoints} ${context.l10n.pointsText}',
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceBadge extends StatelessWidget {
  const _PlaceBadge({required this.place});

  final int place;

  @override
  Widget build(BuildContext context) {
    final Color? medalColor = switch (place) {
      1 => CaboTheme.firstPlaceColor,
      2 => CaboTheme.secondPlaceColor,
      3 => CaboTheme.thirdPlaceColor,
      _ => null,
    };

    if (medalColor != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: medalColor.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: medalColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            '$place',
            style: CaboTheme.labelLargeStyle.copyWith(color: medalColor),
          ),
        ),
      );
    }

    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '$place',
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
