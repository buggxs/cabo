import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/points_entry_sheet.dart';
import 'package:flutter/material.dart';

/// Number pad of the [PointsEntrySheet] with next and done actions.
class PointsKeypad extends StatelessWidget {
  const PointsKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onNext,
    required this.onDone,
    required this.isDoneEnabled,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onNext;
  final VoidCallback onDone;
  final bool isDoneEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CaboTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2.2,
            children: <Widget>[
              for (final String digit in <String>[
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
              ])
                _KeypadButton(
                  label: digit,
                  backgroundColor: CaboTheme.surface,
                  foregroundColor: CaboTheme.onSurface,
                  onTap: () => onDigit(digit),
                ),
              _KeypadButton(
                icon: Icons.backspace_outlined,
                backgroundColor: CaboTheme.surface,
                foregroundColor: CaboTheme.onSurfaceVariant,
                onTap: onBackspace,
              ),
              _KeypadButton(
                label: '0',
                backgroundColor: CaboTheme.surface,
                foregroundColor: CaboTheme.onSurface,
                onTap: () => onDigit('0'),
              ),
              _KeypadButton(
                label: context.l10n.dialogKeypadNext,
                backgroundColor: CaboTheme.secondaryContainer,
                foregroundColor: CaboTheme.onSecondaryContainer,
                isLabel: true,
                onTap: onNext,
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _KeypadButton(
              label: context.l10n.dialogKeypadDone,
              backgroundColor: CaboTheme.primaryContainer,
              foregroundColor: CaboTheme.onPrimaryContainer,
              isLabel: true,
              isEnabled: isDoneEnabled,
              onTap: onDone,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    this.label,
    this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.isLabel = false,
    this.isEnabled = true,
  }) : assert(label != null || icon != null);

  final String? label;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final bool isLabel;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 24, color: foregroundColor)
                : Text(
                    label!,
                    style: isLabel
                        ? CaboTheme.labelLargeStyle.copyWith(
                            color: foregroundColor,
                            fontWeight: FontWeight.bold,
                          )
                        : CaboTheme.headlineMediumStyle.copyWith(
                            color: foregroundColor,
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}
