import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Bottom sheet for entering round points with a custom keypad
/// (see design/track-points.html). Returns a map `player name -> points`
/// via `Navigator.pop`. "Done" is only enabled once all fields are filled,
/// so the map never contains `null` values. Dismissing the sheet returns
/// `null`.
class PointsEntrySheet extends StatefulWidget {
  const PointsEntrySheet({super.key, required this.players, this.closer});

  final List<Player> players;

  /// Player who closed the round; highlighted in the grid.
  final Player? closer;

  @override
  State<PointsEntrySheet> createState() => _PointsEntrySheetState();
}

class _PointsEntrySheetState extends State<PointsEntrySheet> {
  static const int _maxPoints = 50;

  /// Entered points per player, index-parallel to [widget.players].
  late final List<String> _values = List<String>.filled(
    widget.players.length,
    '',
  );
  int _activeIndex = 0;

  int get _roundNumber => (widget.players.firstOrNull?.rounds.length ?? 0) + 1;

  bool get _allFilled => _values.every((String v) => v.isNotEmpty);

  void _onDigit(String digit) {
    final String candidate = _values[_activeIndex] == '0'
        ? digit
        : _values[_activeIndex] + digit;
    final int? points = int.tryParse(candidate);
    if (points == null || points > _maxPoints) {
      return;
    }
    setState(() => _values[_activeIndex] = candidate);
  }

  void _onBackspace() {
    if (_values[_activeIndex].isEmpty) {
      return;
    }
    setState(() {
      _values[_activeIndex] = _values[_activeIndex].substring(
        0,
        _values[_activeIndex].length - 1,
      );
    });
  }

  void _onNext() {
    if (_activeIndex < widget.players.length - 1) {
      setState(() => _activeIndex++);
    }
  }

  void _onDone() {
    if (!_allFilled) {
      return;
    }
    final Map<String, int?> result = {
      for (int i = 0; i < widget.players.length; i++)
        widget.players[i].name: int.tryParse(_values[i]),
    };
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final double maxCardsHeight = MediaQuery.of(context).size.height * 0.32;

    return Container(
      decoration: const BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x263D3A35), // rgba(61,58,53,0.15)
            blurRadius: 32,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: CaboTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Text(
              context.l10n.dialogEnterPoints,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              context.l10n.dialogPointsRoundFinished(_roundNumber),
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // Only the player cards scroll; header and keypad stay fixed.
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxCardsHeight),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.7,
                children: [
                  for (int i = 0; i < widget.players.length; i++)
                    _PlayerEntry(
                      name: widget.players[i].name,
                      value: _values[i],
                      active: _activeIndex == i,
                      isCloser: widget.players[i] == widget.closer,
                      onTap: () => setState(() => _activeIndex = i),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _Keypad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onNext: _onNext,
                onDone: _onDone,
                doneEnabled: _allFilled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerEntry extends StatelessWidget {
  const _PlayerEntry({
    required this.name,
    required this.value,
    required this.active,
    required this.isCloser,
    required this.onTap,
  });

  final String name;
  final String value;
  final bool active;
  final bool isCloser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFFDF5EE)
              : CaboTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          border: Border.all(
            color: active
                ? CaboTheme.primaryContainer
                : CaboTheme.outlineVariant.withValues(alpha: 0.3),
            width: active ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (isCloser) ...[
                  const Icon(
                    Icons.flag_rounded,
                    size: 14,
                    color: CaboTheme.m3Primary,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    name,
                    style: CaboTheme.labelSmallStyle.copyWith(
                      color: isCloser ? CaboTheme.m3Primary : CaboTheme.outline,
                      fontWeight: isCloser ? FontWeight.bold : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBE3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.isEmpty ? context.l10n.dialogPointsLabel : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: CaboTheme.headlineMediumStyle.copyWith(
                  color: value.isEmpty
                      ? CaboTheme.onSurfaceVariant.withValues(alpha: 0.5)
                      : CaboTheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.onNext,
    required this.onDone,
    required this.doneEnabled,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onNext;
  final VoidCallback onDone;
  final bool doneEnabled;

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
        children: [
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2.2,
            children: [
              for (final String d in [
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
                  label: d,
                  backgroundColor: CaboTheme.surface,
                  foregroundColor: CaboTheme.onSurface,
                  onTap: () => onDigit(d),
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
              enabled: doneEnabled,
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
    this.enabled = true,
  }) : assert(label != null || icon != null);

  final String? label;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final bool isLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: InkWell(
          onTap: enabled ? onTap : null,
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
