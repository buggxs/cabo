import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/data_table.dart';
import 'package:cabo/components/statistics/widgets/round_row.dart';
import 'package:cabo/components/statistics/widgets/statistic_info_card.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreenContentBody extends StatelessWidget {
  const StatisticsScreenContentBody({super.key});

  @override
  Widget build(BuildContext context) {
    StatisticsCubit cubit = context.watch<StatisticsCubit>();
    StatisticsState state = cubit.state;

    List<TitleCell> titleCells = state.players
        .map(
          (Player player) => TitleCell(
            player: player,
            isLastColumn: player == state.players.last,
          ),
        )
        .toList();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatisticInfoCard(
                    title: AppLocalizations.of(context)!.statsCardRound,
                    content: (state.players.firstOrNull?.rounds.length ?? 0)
                        .toString(),
                  ),
                  StatisticInfoCard(
                    title: AppLocalizations.of(context)!.statsCardTime,
                    shouldBeTimer: true,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: CaboTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
                  border: Border.all(color: CaboTheme.outlineVariant),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x143D3A35), // rgba(61,58,53,0.08)
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: (state.players.isEmpty)
                    ? const Center(child: Text('No Players found!'))
                    : CaboDataTable(
                        titleCells: titleCells,
                        rounds: _buildRounds(state.players, cubit),
                        cubit: cubit,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRounds(List<Player> players, StatisticsCubit cubit) {
    final int lastIndex = players.first.rounds.length - 1;

    return <Widget>[
      for (int i = 0; i <= lastIndex; i++)
        RoundRow(
          rounds: players.map((Player player) => player.rounds[i]).toList(),
          isLastRound: i == lastIndex,
          onTap: () => cubit.closeRound(index: lastIndex),
        ),
    ];
  }
}
