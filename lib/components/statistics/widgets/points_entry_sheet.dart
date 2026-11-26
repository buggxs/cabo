import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/statistics/widgets/points_keypad.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Bottom sheet for entering round points with a custom keypad
/// (see design/track-points.html). Pops with a map `player name -> points`.
/// "Done" is only enabled once all fields are filled, so the map never
/// contains `null` values. Dismissing the sheet returns `null`.
class PointsEntrySheet extends StatefulWidget {
  const PointsEntrySheet({super.key, required this.players, this.closer});

  final List<Player> players;

  // Highlighted in the grid.
  final Player? closer;

  @override
  State<PointsEntrySheet> createState() => _PointsEntrySheetState();
}

class _PointsEntrySheetState extends State<PointsEntrySheet> {
  // Highest possible hand: four cards, at best two 13s and two 12s.
  static const int _maxPoints = 50;

  // Entered points per player, index-parallel to widget.players.
  late final List<String> _values = List<String>.filled(
    widget.players.length,
    '',
  );
  int _activeIndex = 0;

  int get _roundNumber => (widget.players.firstOrNull?.rounds.length ?? 0) + 1;

  bool get _hasAllValues => _values.every((String value) => value.isNotEmpty);

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
    if (!_hasAllValues) {
      return;
    }
    final Map<String, int?> result = <String, int?>{
      for (int i = 0; i < widget.players.length; i++)
        widget.players[i].name: int.tryParse(_values[i]),
    };
    app<NavigationService>().pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const <BoxShadow>[
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
          children: <Widget>[
            ..._buildHeader(context),
            const SizedBox(height: 16),
            _buildPlayerGrid(context),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: PointsKeypad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onNext: _onNext,
                onDone: _onDone,
                isDoneEnabled: _hasAllValues,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    return <Widget>[
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
    ];
  }

  // Only the player cards scroll; header and keypad stay fixed.
  Widget _buildPlayerGrid(BuildContext context) {
    final double maxCardsHeight = MediaQuery.of(context).size.height * 0.32;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxCardsHeight),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
        children: <Widget>[
          for (int i = 0; i < widget.players.length; i++)
            _PlayerEntry(
              name: widget.players[i].name,
              value: _values[i],
              isActive: _activeIndex == i,
              isCloser: widget.players[i] == widget.closer,
              onTap: () => setState(() => _activeIndex = i),
            ),
        ],
      ),
    );
  }
}

class _PlayerEntry extends StatelessWidget {
  const _PlayerEntry({
    required this.name,
    required this.value,
    required this.isActive,
    required this.isCloser,
    required this.onTap,
  });

  final String name;
  final String value;
  final bool isActive;
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
          color: isActive
              ? (CaboTheme.isClassic
                    ? CaboTheme.background
                    : const Color(0xFFFDF5EE))
              : CaboTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          border: Border.all(
            color: isActive
                ? CaboTheme.primaryContainer
                : CaboTheme.outlineVariant.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (isCloser) ...<Widget>[
                  Icon(
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
                color: CaboTheme.isClassic
                    ? CaboTheme.surfaceContainer
                    : const Color(0xFFF0EBE3),
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
