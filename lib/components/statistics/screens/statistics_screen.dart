import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/statistics_bottom_nav.dart';
import 'package:cabo/components/statistics/widgets/statistics_screen_content_body.dart';
import 'package:cabo/components/statistics/widgets/winner_dialog.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.players, this.game});

  static const String route = 'statistics_screen';
  final List<Player> players;
  final Game? game;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => StatisticsCubit(players: players, game: game),
      child: const StatisticsScreenContent(),
    );
  }
}

class StatisticsScreenContent extends StatelessWidget {
  const StatisticsScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    StatisticsCubit cubit = context.watch<StatisticsCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CaboTheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CaboTheme.primaryContainer,
        onPressed: () => cubit.closeRound(),
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 28,
          color: CaboTheme.onPrimaryContainer,
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CaboTheme.background,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          '${context.l10n.gameName} ${context.l10n.gameSubTitle}',
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.m3Primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: StatisticsBottomNav(
        isOnline: cubit.state.game?.isPublic ?? false,
        onEndGame: () => _onPopScreen(cubit, context),
        onRules: () => Navigator.of(context).pushNamed(RuleSetScreen.route),
        onOnline: () => cubit.showPublicGameDialog(context),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          await _onPopScreen(cubit, context);
        },
        child: const StatisticsScreenContentBody(),
      ),
    );
  }

  Future<bool> _onPopScreen(StatisticsCubit cubit, BuildContext context) async {
    bool shouldPop = false;
    await Future.delayed(Duration.zero, () async {
      shouldPop =
          await app<StatisticsDialogService>().showEndGame(cubit.state.game) ??
          false;
    });

    if (!shouldPop) {
      return false;
    }

    // Owner setzt hier finishedAt + synct zu Firestore → Mitspieler bekommen
    // den Dialog via Listener. Non-Owner verlässt nur lokal.
    await cubit.onPopScreen();

    final Player? winner = cubit.state.game?.players
        .where((player) => player.place == 1)
        .firstOrNull;
    final bool gameFinished = cubit.state.game?.isGameFinished ?? false;

    if (winner != null && gameFinished) {
      await app<NavigationService>().showAppDialog(
        dialog: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              style: BorderStyle.solid,
              color: CaboTheme.tertiaryColor,
              width: 2,
            ),
          ),
          backgroundColor: CaboTheme.secondaryColor,
          child: WinnerDialog(winner: winner),
        ),
      );
    }

    if (context.mounted) {
      Navigator.of(context).popAndPushNamed(MainMenuScreen.route);
    }

    app<RatingService>().trackGameCompletion();

    return false;
  }
}
