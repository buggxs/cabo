import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/data_table.dart';
import 'package:cabo/components/statistics/widgets/statistic_info_card.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'animated_border_container.dart';

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
      child: DarkScreenOverlay(
        darken: 0.20,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatisticInfoCard(
                          title: AppLocalizations.of(context)!.statsCardRound,
                          content: state.players.first.rounds.length.toString(),
                        ),
                        StatisticInfoCard(
                          title: AppLocalizations.of(context)!.statsCardTime,
                          shouldBeTimer: true,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Card(
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
                              rounds: _buildRounds(state.players, cubit),
                              cubit: cubit,
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRounds(List<Player> players, StatisticsCubit cubit) {
    List<Widget> rounds = <Widget>[];
    int lastIndex = players.first.rounds.length - 1;
    for (int i = 0; i < players.first.rounds.length; i++) {
      Widget roundRow = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ...players.map(
            (Player player) => CaboDataCell(
              round: player.rounds[i],
              isLastColumn: player == players.last,
            ),
          ),
        ],
      );

      if (i == lastIndex) {
        rounds.add(
          AnimatedBorderContainer(
            onTap: () => cubit.closeRound(index: lastIndex),
            child: roundRow,
          ),
        );
      } else {
        rounds.add(roundRow);
      }
    }
    return rounds;
  }
}
