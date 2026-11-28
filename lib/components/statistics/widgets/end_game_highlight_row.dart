import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Single highlight entry: a round icon badge with title and subtitle.
class EndGameHighlightRow extends StatelessWidget {
  const EndGameHighlightRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconFg, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: CaboTheme.bodyMediumStyle.copyWith(
                  color: CaboTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: CaboTheme.labelSmallStyle.copyWith(
                  color: CaboTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
