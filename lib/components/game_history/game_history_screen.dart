import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/components/game_history/cubit/game_history_cubit.dart';
import 'package:cabo/components/game_history/widget/game_card.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/misc/utils/gaming_data.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  static const String route = 'game_history_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameHistoryCubit()..loadGames(),
      child: const GameHistoryScreenContent(),
    );
  }
}

class GameHistoryScreenContent extends StatelessWidget {
  const GameHistoryScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameHistoryCubit cubit = context.watch<GameHistoryCubit>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              _headerCards(
                playedRounds: calculatePlayedRounds(
                  cubit.state.games,
                ),
                gameAmount: cubit.state.games.length,
                gameTime: calculateTotalPlayTime(cubit.state.games),
              ),
              _totalPointsBanner(
                totalCollectedPoints: calculateTotalPoints(
                  cubit.state.games,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _generateList(cubit.state.games),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _generateList(List<Game> games) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < games.length; i++) {
      children.add(
        Padding(
          padding: i % 2 == 0
              ? const EdgeInsets.only(right: 50)
              : const EdgeInsets.only(left: 50),
          child: GameCard(
            game: games[i],
          ),
        ),
      );
    }
    return children;
  }

  Widget _headerCards({
    int gameAmount = 0,
    int playedRounds = 0,
    String gameTime = '0 Days \n 0 hours',
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            color: CaboTheme.secondaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Games',
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.fourthColor,
                      height: 1,
                    ),
                  ),
                  Text(
                    '$gameAmount',
                    style: CaboTheme.numberTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            color: CaboTheme.secondaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Game Time',
                    textAlign: TextAlign.center,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.fourthColor,
                      height: 1,
                      fontSize: 14,
                    ),
                  ),
                  AutoSizeText(
                    gameTime,
                    textAlign: TextAlign.center,
                    style: CaboTheme.numberTextStyle
                        .copyWith(color: Colors.white, fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            color: CaboTheme.secondaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Played Rounds',
                    textAlign: TextAlign.center,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.fourthColor,
                      height: 1,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$playedRounds',
                    style: CaboTheme.numberTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalPointsBanner({int totalCollectedPoints = 0}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Card(
            color: CaboTheme.secondaryBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Total amount of collected Points',
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.fourthColor,
                      height: 1,
                    ),
                  ),
                  Text(
                    '$totalCollectedPoints',
                    style: CaboTheme.numberTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
