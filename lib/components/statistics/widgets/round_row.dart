import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/animated_border_container.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:flutter/material.dart';

/// One row of the score table, holding the round of every player. A kamikaze
/// is highlighted as a whole row instead of repeating a badge in every column.
class RoundRow extends StatelessWidget {
  const RoundRow({
    super.key,
    required this.rounds,
    this.isLastRound = false,
    this.onTap,
  });

  final List<Round> rounds;
  final bool isLastRound;
  final VoidCallback? onTap;

  bool get _isKamikazeRound =>
      rounds.isNotEmpty && rounds.first.isKamikazeRound;

  @override
  Widget build(BuildContext context) {
    final Widget row = DecoratedBox(
      decoration: _buildDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          for (int i = 0; i < rounds.length; i++)
            CaboDataCell(
              round: rounds[i],
              isLastColumn: i == rounds.length - 1,
            ),
        ],
      ),
    );

    if (!isLastRound) {
      return row;
    }
    return AnimatedBorderContainer(onTap: onTap, child: row);
  }

  BoxDecoration _buildDecoration() {
    if (_isKamikazeRound) {
      return BoxDecoration(
        color: CaboTheme.errorContainer.withValues(alpha: 0.5),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: CaboTheme.m3Error.withValues(alpha: 0.35),
          ),
        ),
      );
    }

    if (isLastRound) {
      return const BoxDecoration();
    }

    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: CaboTheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
