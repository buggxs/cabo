import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/main_menu/widgets/round_indicator.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/data_table.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatisticsScreenContentBody extends StatelessWidget {
  const StatisticsScreenContentBody({super.key});

  @override
  Widget build(BuildContext context) {
    StatisticsCubit cubit = context.watch<StatisticsCubit>();
    StatisticsState state = cubit.state;

    List<TitleCell> titleCells = state.players
        .map(
          (Player player) => TitleCell(
            titleStyle: title,
            player: player,
            isLastColumn: player == state.players.last,
          ),
        )
        .toList();

    return PopScope(
      onPopInvoked: (_) => _onPopScreen(context, cubit),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromRGBO(81, 120, 30, 1.0),
              ),
            ),
            margin: const EdgeInsets.all(12.0),
            color: const Color.fromRGBO(32, 45, 18, 0.8),
            shadowColor: Colors.black,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 4.0,
              ),
              child: (state.players.isEmpty)
                  ? const Text('No Players found!')
                  : CaboDataTable(
                      titleCells: titleCells,
                      rounds: _buildRounds(state.players),
                      cubit: cubit,
                    ),
            ),
          ),
        ),
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
            RoundIndicator(
              round: players.first.rounds[i].round,
            ),
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

  Future<bool> _onPopScreen(BuildContext context, StatisticsCubit cubit) async {
    StatisticsState state = cubit.state;
    final bool shouldPop =
        await app<StatisticsDialogService>().showEndGame(context) ?? false;
    if (context.mounted) {
      if (shouldPop) {
        cubit.client?.deactivate();
        DateTime finishedAt = DateTime.now();
        app<GameService>().saveToGameHistory(
          state.game!.copyWith(
            finishedAt: DateFormat('dd-MM-yyyy').format(finishedAt),
          ),
        );
        Navigator.of(context).popAndPushNamed(MainMenuScreen.route);
      }
    }

    return false;
  }
}
