import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/end_game_card_shadow.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Two summary tiles of the finished game: its duration and the round count.
class EndGameSummaryRow extends StatelessWidget {
  const EndGameSummaryRow({
    super.key,
    required this.game,
    required this.roundCount,
  });

  final Game game;
  final int roundCount;

  @override
  Widget build(BuildContext context) {
    final (String, String) duration = _formatDuration(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: _SummaryCard(
            icon: Icons.schedule,
            label: context.l10n.endGameDurationLabel,
            value: duration.$1,
            unit: duration.$2,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            icon: Icons.style,
            label: context.l10n.endGameRoundsLabel,
            value: '$roundCount',
            unit: context.l10n.endGameRoundsUnit,
          ),
        ),
      ],
    );
  }

  // Returns (value, unit) of the game duration, or '–' for missing or
  // invalid timestamps.
  (String, String) _formatDuration(BuildContext context) {
    final String? startedAt = game.startedAt;
    final String? finishedAt = game.finishedAt;
    if (startedAt == null ||
        startedAt.isEmpty ||
        finishedAt == null ||
        finishedAt.isEmpty) {
      return ('–', context.l10n.endGameDurationUnitMinutes);
    }

    try {
      final DateFormat format = DateFormat('dd-MM-yyyy HH:mm');
      final Duration diff = format
          .parse(finishedAt)
          .difference(format.parse(startedAt));
      final int totalMinutes = diff.inMinutes;
      if (totalMinutes >= 60) {
        final int hours = totalMinutes ~/ 60;
        final int minutes = totalMinutes % 60;
        return (
          '$hours:${minutes.toString().padLeft(2, '0')}',
          context.l10n.endGameDurationUnitHours,
        );
      }
      return ('$totalMinutes', context.l10n.endGameDurationUnitMinutes);
    } on FormatException {
      return ('–', context.l10n.endGameDurationUnitMinutes);
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: endGameCardShadow,
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: CaboTheme.m3Primary, size: 22),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: value,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' $unit',
                  style: CaboTheme.bodyMediumStyle.copyWith(
                    color: CaboTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
