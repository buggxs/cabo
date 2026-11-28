import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/rule_set/widgets/rule_card.dart';
import 'package:flutter/material.dart';

/// Rule card with a title, a description and a switch to enable the rule.
class RuleToggleCard extends StatelessWidget {
  const RuleToggleCard({
    required this.title,
    required this.description,
    required this.isEnabled,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return RuleCard(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: CaboTheme.bodyLargeStyle.copyWith(
                    color: CaboTheme.m3Primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: CaboTheme.labelSmallStyle.copyWith(
                    color: CaboTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: CaboTheme.onSecondary,
            activeTrackColor: CaboTheme.m3Secondary,
            inactiveThumbColor: CaboTheme.surfaceContainerLowest,
            inactiveTrackColor: CaboTheme.surfaceVariant,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
