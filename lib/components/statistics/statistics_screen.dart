import 'package:cabo/components/main_menu/main_menu_screen.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/statistics_screen_content_body.dart';
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
    this.shouldUseSpecialRules = false,
    this.game,
  }) : super(key: key);

  static const String route = 'statistics_screen';
  final List<Player> players;
  final bool? shouldUseSpecialRules;
  final Game? game;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(
        players: players,
        useOwnRuleSet: shouldUseSpecialRules ?? false,
        game: game,
      ),
      child: const StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  const StatisticsScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StatisticsCubit cubit = context.watch<StatisticsCubit>();

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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => _onPopScreen(context, cubit),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
            ),
            onPressed: () => _publishGameDialog(
              context,
              cubit.publishGame,
            ),
          )
        ],
      ),
      body: const StatisticsScreenContentBody(),
    );
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
