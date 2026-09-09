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
    this.icon,
    this.tooltip,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final String? tooltip;

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
          if (icon != null) ...<Widget>[
            Icon(icon, size: 11, color: foregroundColor),
            const SizedBox(width: 2),
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
