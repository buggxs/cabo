import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/round_badge.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
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
        ? round.points - kFailedCaboPenaltyPoints
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
      // Mehrere Badges in einer Zelle dürfen nicht überlaufen.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            ..._buildBadges(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBadges(BuildContext context) {
    return <Widget>[
      if (round.hasPenaltyPoints) ...<Widget>[
        const SizedBox(width: 6),
        RoundBadge(
          label: '+$kFailedCaboPenaltyPoints',
          tooltip: context.l10n.roundBadgePenaltyTooltip,
          backgroundColor: CaboTheme.primaryContainer,
          foregroundColor: CaboTheme.onPrimaryContainer,
        ),
      ],
      // Die Runde selbst ist als Zeile hervorgehoben, das Badge markiert nur
      // noch, wer den Kamikaze gespielt hat.
      if (round.isKamikazeRound && round.isWonRound) ...<Widget>[
        const SizedBox(width: 6),
        RoundBadge(
          label: context.l10n.roundBadgeKamikaze,
          iconAsset: 'assets/images/badge_kamikaze.png',
          tooltip: context.l10n.roundBadgeKamikazeTooltip,
          backgroundColor: CaboTheme.errorContainer,
          foregroundColor: CaboTheme.m3Error,
        ),
      ],
      if (round.hasPrecisionLanding) ...<Widget>[
        const SizedBox(width: 6),
        RoundBadge(
          label: '-${round.precisionLandingDeduction ?? 50}',
          iconAsset: 'assets/images/badge_precision_landing.png',
          tooltip: context.l10n.roundBadgePrecisionLandingTooltip,
          backgroundColor: CaboTheme.secondaryContainer,
          foregroundColor: CaboTheme.onSecondaryContainer,
        ),
      ],
    ];
  }
}
