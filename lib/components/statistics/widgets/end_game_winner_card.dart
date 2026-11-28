import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/end_game_card_shadow.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Hero card celebrating the winner of the game with trophy and total points.
class EndGameWinnerCard extends StatelessWidget {
  const EndGameWinnerCard({super.key, required this.winner});

  final Player winner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(
          color: CaboTheme.primaryContainer.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: endGameCardShadow,
      ),
      child: Column(
        children: <Widget>[
          _buildTrophy(),
          const SizedBox(height: 16),
          AutoSizeText(
            '${winner.name} ${context.l10n.hasWonText}',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.l10n.withPointsText} ${winner.totalPoints} ${context.l10n.pointsText}',
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.m3Primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrophy() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        color: CaboTheme.primaryFixedDim.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Image(
          image: AssetImage('assets/icon/winner_trophy.png'),
          width: 72,
        ),
      ),
    );
  }
}
