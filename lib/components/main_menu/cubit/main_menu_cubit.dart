import 'package:bloc/bloc.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/screens/join_game_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'main_menu_state.dart';

class MainMenuCubit extends Cubit<MainMenuState> with LoggerMixin {
  MainMenuCubit() : super(MainMenu());

  void _pushToStatsScreen(
    List<Player> players, {
    bool? shouldUseSpecialRules,
    Game? game,
  }) {
    app<NavigationService>().pushToStatsScreen(
      players: players,
      shouldUseSpecialRules: shouldUseSpecialRules,
      game: game,
    );
  }

  void pushToScreen(BuildContext context, String? route) {
    logger.info('History screen');
    Navigator.of(context).pushNamed(route ?? GameHistoryScreen.route);
  }

  void showJoinGameDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const JoinGameScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> checkForPossibleGame({bool? useOwnRuleSet}) async {
    Game? game = await app<GameService>().getLastPlayedGame();
    BuildContext currentContext =
        app<NavigationService>().navigatorKey.currentContext!;
    if (!(game?.isGameFinished ?? true)) {
      bool? shouldLoadGame = await app<StatisticsDialogService>()
          .loadNotFinishedGame();

      if (shouldLoadGame == null) {
        return;
      }

      if (shouldLoadGame) {
        if (currentContext.mounted) {
          _pushToStatsScreen(game!.players, game: game);
          return;
        }
      }
    }
    emit(const ChoosePlayerAmount());
  }

  void showChoosePlayerAmountScreen() {
    checkForPossibleGame();
  }

  void increasePlayerAmount() {
    if (state is ChoosePlayerAmount) {
      ChoosePlayerAmount updatedState = (state as ChoosePlayerAmount);
      int playerAmount = updatedState.playerAmount + 1;

      if (playerAmount > 10) {
        return;
      }

      emit(updatedState.copyWith(playerAmount: playerAmount));
    }
  }

  void decreasePlayerAmount() {
    if (state is ChoosePlayerAmount) {
      ChoosePlayerAmount updatedState = (state as ChoosePlayerAmount);
      int playerAmount = updatedState.playerAmount - 1;

      if (playerAmount < 0) {
        return;
      }

      emit(updatedState.copyWith(playerAmount: playerAmount));
    }
  }

  void continueToPlayerNameScreen() {
    if (state is ChoosePlayerAmount) {
      emit(
        ChoosePlayerNames(
          playerAmount: (state as ChoosePlayerAmount).playerAmount,
          shouldUseSpecialRules:
              (state as ChoosePlayerAmount).shouldUseSpecialRules,
        ),
      );
    }
  }

  void submitPlayerName(String playerName) {
    if (state is ChoosePlayerNames) {
      ChoosePlayerNames currentState = state as ChoosePlayerNames;
      emit(
        currentState.copyWith(
          playerNames: [...currentState.playerNames, playerName],
        ),
      );
    }
  }

  void startGame(GlobalKey<FormState> formKey) {
    List<Player> players = <Player>[];
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ChoosePlayerNames currentState = state as ChoosePlayerNames;
      if (currentState.playerNames.isNotEmpty) {
        players = (state as ChoosePlayerNames).playerNames
            .map((String name) => Player(name: name))
            .toList();
      }
    }
    _pushToStatsScreen(
      players,
      shouldUseSpecialRules: (state as ChoosePlayerNames).shouldUseSpecialRules,
    );
  }

  Future<bool> onWillPop() async {
    if (state is ChoosePlayerAmount) {
      emit(MainMenu());
      return false;
    } else if (state is ChoosePlayerNames) {
      emit(const ChoosePlayerAmount());
      return false;
    } else if (state is MainMenu) {
      return false;
    }
    return false;
  }
}
