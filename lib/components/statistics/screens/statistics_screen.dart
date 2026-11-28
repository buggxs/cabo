import 'dart:async';

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/components/statistics/widgets/statistics_bottom_nav.dart';
import 'package:cabo/components/statistics/widgets/statistics_screen_content_body.dart';
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
      child: const _StatisticsScreenContent(),
    );
  }
}

class _StatisticsScreenContent extends StatelessWidget {
  const _StatisticsScreenContent();

  @override
  Widget build(BuildContext context) {
    final StatisticsCubit cubit = context.watch<StatisticsCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CaboTheme.scaffoldBackground,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CaboTheme.primaryContainer,
        onPressed: () => cubit.closeRound(),
        elevation: 4.0,
        shape: const CircleBorder(),
        child: Icon(Icons.add, size: 28, color: CaboTheme.onPrimaryContainer),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CaboTheme.scaffoldBackground,
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
        onRules: () async {
          await app<NavigationService>().pushNamed<void>(RuleSetScreen.route);
          await cubit.reloadRuleSet();
        },
        onOnline: cubit.showPublicGameDialog,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) async {
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
    await Future<void>.delayed(Duration.zero, () async {
      shouldPop =
          await app<StatisticsDialogService>().showEndGame(cubit.state.game) ??
          false;
    });

    if (!shouldPop) {
      return false;
    }

    // The owner sets finishedAt and syncs to Firestore here, so the other
    // players get the dialog via their listener. A non-owner only leaves locally.
    await cubit.onPopScreen();

    final Player? winner = cubit.state.game?.players
        .where((Player player) => player.place == 1)
        .firstOrNull;
    final bool isGameFinished = cubit.state.game?.isGameFinished ?? false;

    // A finished game hands ranking, menu routing and trackGameCompletion over
    // to the EndGameScreen. Otherwise (e.g. a non-owner only leaving a public
    // game locally) go straight back to the main menu.
    if (winner != null && isGameFinished) {
      app<NavigationService>().pushToEndGameScreen(game: cubit.state.game!);
      return false;
    }

    if (context.mounted) {
      app<NavigationService>().popAndPushNamed(MainMenuScreen.route);
    }

    unawaited(app<RatingService>().trackGameCompletion());

    return false;
  }
}
