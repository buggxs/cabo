import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/data_table.dart';
import 'package:cabo/components/statistics/widgets/statistic_info_card.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
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
            titleStyle: title.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CaboTheme.primaryGreenColor,
            ),
            player: player,
            isLastColumn: player == state.players.last,
          ),
        )
        .toList();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/cabo-main-menu-background.png'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatisticInfoCard(
                title: 'Round',
                content: state.players.first.rounds.length.toString(),
              ),
              const StatisticInfoCard(
                title: 'Play time',
                shouldBeTimer: true,
              ),
            ],
          ),
          const SizedBox(
            height: 75,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(12.0),
            color: CaboTheme.secondaryBackgroundColor,
            shadowColor: Colors.black,
            elevation: 5.0,
            child: (state.players.isEmpty)
                ? const Text('No Players found!')
                : CaboDataTable(
                    titleCells: titleCells,
                    rounds: _buildRounds(state.players),
                    cubit: cubit,
                  ),
          ),
        ],
      ),
    );
  }

  List<Row> _buildRounds(List<Player> players) {
    List<Row> rounds = <Row>[];
    for (int i = 0; i < players.first.rounds.length; i++) {
      rounds.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ...players
                .map(
                  (Player player) => CaboDataCell(
                    round: player.rounds[i],
                    isLastColumn: player == players.last,
                  ),
                )
                .toList(),
          ],
        ),
      );
    }
    return rounds;
  }
}
