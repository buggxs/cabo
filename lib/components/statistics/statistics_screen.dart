import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  static const String route = 'statistics_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit()..getPlayers(),
      child: StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  StatisticsScreenContent({Key? key}) : super(key: key);

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

  final FocusNode name1 = FocusNode();
  final FocusNode name2 = FocusNode();
  final FocusNode name3 = FocusNode();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRoundCloserDialog(
          context,
          state.players,
        ),
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
        child: SafeArea(
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
                        scrollDirection: Axis.horizontal,
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

  Future<void> showRoundCloserDialog(
    BuildContext context,
    List<Player>? players,
  ) {
    List<OutlinedButton> buttons = players
            ?.map(
              (Player player) => OutlinedButton(
                style: dialogButtonStyle,
                onPressed: () {
                  showPointDialog(context);
                },
                child: Text(player.name),
              ),
            )
            .toList() ??
        <OutlinedButton>[];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Wer hat die Runde beendet?',
                style: title,
              ),
              if (buttons.isNotEmpty) ...buttons
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> showPointDialog(BuildContext context) {
    Navigator.of(context).pop();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Punkte eintragen',
                style: title,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Player 1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        style: TextStyle(fontSize: 18),
                        decoration: dialogPointInputStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Player 1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        style: TextStyle(fontSize: 18),
                        decoration: dialogPointInputStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Player 1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        minLines: 1,
                        style: TextStyle(fontSize: 18),
                        decoration: dialogPointInputStyle,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text('Eintragen'),
                style: dialogButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
