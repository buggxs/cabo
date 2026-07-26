import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/failure_chip.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:flutter/material.dart';

class CaboDataCell extends StatelessWidget {
  const CaboDataCell({
    super.key,
    required this.round,
    this.isLastColumn = false,
  });

  final Round round;
  final bool isLastColumn;

  @override
  Widget build(BuildContext context) {
    // Anzeige rechnet den +5-Aufschlag wieder heraus (er wird als Badge gezeigt).
    final int displayPoints = round.hasPenaltyPoints
        ? round.points - 5
        : round.points;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          right: isLastColumn
              ? BorderSide.none
              : BorderSide(
                  color: CaboTheme.outlineVariant.withValues(alpha: 0.4),
                ),
        ),
      ),
      width: CaboTheme.cellWidth,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (round.isWonRound)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Icon(
                Icons.emoji_events,
                size: 16,
                color: CaboTheme.m3Tertiary,
              ),
            ),
          Text(
            '$displayPoints',
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          if (round.hasPenaltyPoints) ...[
            const SizedBox(width: 6),
            const FailureChip(chipContent: '+5'),
          ],
          if (round.hasPrecisionLanding) ...[
            const SizedBox(width: 6),
            Text(
              '-50',
              style: CaboTheme.labelLargeStyle.copyWith(
                fontSize: 13,
                color: CaboTheme.m3Secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
