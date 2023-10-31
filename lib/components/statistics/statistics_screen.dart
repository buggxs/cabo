import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    Key? key,
    required this.players,
  }) : super(key: key);

  static const String route = 'statistics_screen';
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(players: players),
      child: StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  StatisticsScreenContent({Key? key}) : super(key: key);

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  final TextStyle title = const TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  final InputDecoration inputDecoration = const InputDecoration(
    border: InputBorder.none,
  );

  final ButtonStyle dialogButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.black,
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
            ?.map(
              (Player player) => TitleCell(
                titleStyle: title,
                player: player,
              ),
            )
            .toList() ??
        <TitleCell>[];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () => cubit.closeRound(context),
        elevation: 4.0,
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo_bg_upscaled.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(12.0),
            color: const Color.fromRGBO(202, 255, 202, 0.5647058823529412),
            shadowColor: Colors.black,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8.0,
              ),
              child: (state.players?.isEmpty ?? true)
                  ? const Text('No Players found!')
                  : SingleChildScrollView(
                      controller: _horizontal,
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: _vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                ...titleCells,
                              ],
                            ),
                            ...buildRounds(state.players!),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  List<Row> buildRounds(List<Player> players) {
    List<Row> rounds = <Row>[];
    for (int i = 0; i < players.first.rounds.length; i++) {
      rounds.add(
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 15,
              child: Text(
                '${players.first.rounds[i].round}.)',
                style: const TextStyle(fontSize: 10),
              ),
            ),
            ...players
                .map(
                  (Player player) => CaboDataCell(
                    round: player.rounds[i],
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
