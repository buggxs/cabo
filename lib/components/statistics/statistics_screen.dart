import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/main_menu/widgets/round_indicator.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/cabo_data_cell.dart';
import 'package:cabo/components/statistics/widgets/title_cell.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

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

  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

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
          onPressed: () => onPopScreen(context, cubit),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
            onPressed: () => publishGameDialog(context, cubit.publishGame),
          )
        ],
      ),
      body: PopScope(
        onPopInvoked: (_) => onPopScreen(context, cubit),
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
                                    width: 20,
                                  ),
                                  ...titleCells,
                                ],
                              ),
                              ...buildRounds(state.players),
                            ],
                          ),
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

  Future<bool> onPopScreen(BuildContext context, StatisticsCubit cubit) async {
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
            startedAt: DateFormat.yMd().format(state.startedAt!),
            finishedAt: DateFormat.yMd().format(finishedAt),
          ),
        );
        Navigator.of(context).popAndPushNamed(MainMenuScreen.route);
      }
    }

    return false;
  }

  Future<void> publishGameDialog(
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

class ShowPublishGameScreen extends StatefulWidget {
  const ShowPublishGameScreen({
    super.key,
    required this.publishGame,
  });

  final Future<String?> Function() publishGame;

  @override
  State<ShowPublishGameScreen> createState() => _ShowPublishGameScreenState();
}

class _ShowPublishGameScreenState extends State<ShowPublishGameScreen> {
  String? publicGameId;

  void onPublish() async {
    String? newPublicGameId = await widget.publishGame();
    setState(() {
      publicGameId = newPublicGameId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: publicGameId == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.publishDialogTitle,
                  style: title,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onPublish,
                        style: dialogButtonStyle,
                        child: Text(
                          AppLocalizations.of(context)!
                              .publishDialogButtonPublishText,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: dialogButtonStyle,
                        child: Text(
                          AppLocalizations.of(context)!
                              .publishDialogButtonCloseText,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.publishDialogTitle,
                  style: title,
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      height: 250,
                      width: 250,
                      child: PrettyQrView.data(
                        data:
                            'http://cabo-web.eu-central-1.elasticbeanstalk.com/online-game/$publicGameId',
                      ),
                      // http://192.168.178.23:8080
                      // http://cabo-web.eu-central-1.elasticbeanstalk.com
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
