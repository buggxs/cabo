import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/main_menu/widgets/round_indicator.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/data_table.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/components/widgets/publish_game_dialog.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    Key? key,
    required this.players,
    this.useOwnRuleSet = false,
    this.game,
  }) : super(key: key);

  static const String route = 'statistics_screen';
  final List<Player> players;
  final bool useOwnRuleSet;
  final Game? game;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(
        players: players,
        useOwnRuleSet: useOwnRuleSet,
      )..loadRuleSet(game: game),
      child: StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  StatisticsScreenContent({Key? key}) : super(key: key);

  final TextStyle title = const TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontFamily: 'Aclonica',
    fontSize: 20,
    color: Color.fromRGBO(99, 142, 40, 1.0),
  );

  final InputDecoration inputDecoration = const InputDecoration(
    border: InputBorder.none,
  );

  final ButtonStyle dialogButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: Colors.black,
    side: const BorderSide(
      color: Colors.black,
    ),
  );

  final InputDecoration dialogPointInputStyle = const InputDecoration(
    isDense: true,
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.all(8.0),
  );

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(32, 45, 18, 0.9),
        onPressed: () => cubit.closeRound(),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(
            color: Color.fromRGBO(81, 120, 30, 1.0),
          ),
        ),
        child: const Icon(
          Icons.add,
          size: 28,
          color: Color.fromRGBO(81, 120, 30, 1.0),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _onPopScreen(context, cubit),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
            onPressed: () => _publishGameDialog(context, cubit.publishGame),
          )
        ],
      ),
      body: PopScope(
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
          Game(
            id: state.gameId,
            players: state.players,
            ruleSet: state.ruleSet!,
            startedAt: DateFormat('dd-MM-yyyy').format(state.startedAt!),
            finishedAt: DateFormat('dd-MM-yyyy').format(finishedAt),
          ),
        );
        Navigator.of(context).popAndPushNamed(MainMenuScreen.route);
      }
    }

    return false;
  }

  Future<void> _publishGameDialog(
    BuildContext context,
    Future<String?> Function() publishGame,
  ) async {
    await showDialog(
        context: context,
        builder: (BuildContext localContext) {
          return Dialog(
            backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
            child: ShowPublishGameScreen(
              publishGame: publishGame,
            ),
          );
        });
  }
}
