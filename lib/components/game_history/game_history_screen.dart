import 'package:cabo/components/game_history/cubit/game_history_cubit.dart';
import 'package:cabo/components/game_history/widget/game_card.dart';
import 'package:cabo/domain/game/game.dart';
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
          child: SingleChildScrollView(
            child: Column(
              children: cubit.state.games
                  .map((Game game) => GameCard(game: game))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
