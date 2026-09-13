import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Compact marker next to a round's score, e.g. penalty points, kamikaze or a
/// precision landing.
class RoundBadge extends StatelessWidget {
  const RoundBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.iconAsset,
    this.tooltip,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  /// Optional leading glyph, tinted with [foregroundColor].
  final String? iconAsset;

  final String? tooltip;

  static const double _iconSize = 12;

  @override
  Widget build(BuildContext context) {
    final Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (iconAsset != null) ...<Widget>[
            Image.asset(
              iconAsset!,
              width: _iconSize,
              height: _iconSize,
              color: foregroundColor,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: foregroundColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (tooltip == null) {
      return badge;
    }
    return Tooltip(message: tooltip!, child: badge);
  }
}
