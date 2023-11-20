import 'package:bloc/bloc.dart';
import 'package:cabo/components/statistics/statistics_screen.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'main_menu_state.dart';

class MainMenuCubit extends Cubit<MainMenuState> {
  MainMenuCubit() : super(MainMenu());

  void pushToStatsScreen(
    BuildContext context,
    List<Player> players, {
    bool? useOwnRuleSet,
  }) {
    Navigator.of(context).pushNamed(
      StatisticsScreen.route,
      arguments: {
        'players': players,
        'useOwnRuleSet': useOwnRuleSet,
      },
    );
  }

  void showChoosePlayerAmountScreen({bool? useOwnRuleSet}) {
    emit(ChoosePlayerAmount(useOwnRuleSet: useOwnRuleSet));
  }

  void increasePlayerAmount() {
    if (state is ChoosePlayerAmount) {
      ChoosePlayerAmount updatedState = (state as ChoosePlayerAmount);
      int playerAmount = updatedState.playerAmount + 1;
      emit(updatedState.copyWith(playerAmount: playerAmount));
    }
  }

  void decreasePlayerAmount() {
    if (state is ChoosePlayerAmount) {
      ChoosePlayerAmount updatedState = (state as ChoosePlayerAmount);
      int playerAmount = updatedState.playerAmount - 1;
      emit(updatedState.copyWith(playerAmount: playerAmount));
    }
  }

  void continueToPlayerNameScreen() {
    if (state is ChoosePlayerAmount) {
      emit(
        ChoosePlayerNames(
            playerAmount: (state as ChoosePlayerAmount).playerAmount,
            useOwnRuleSet: (state as ChoosePlayerAmount).useOwnRuleSet),
      );
    }
  }

  void submitPlayerName(String playerName) {
    if (state is ChoosePlayerNames) {
      ChoosePlayerNames currentState = state as ChoosePlayerNames;
      emit(
        currentState.copyWith(
          playerNames: [
            ...currentState.playerNames,
            playerName,
          ],
        ),
      );
    }
  }

  void startGame(BuildContext context, GlobalKey<FormState> formKey) {
    List<Player> players = <Player>[];
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ChoosePlayerNames currentState = state as ChoosePlayerNames;
      if (currentState.playerNames.isNotEmpty) {
        players = (state as ChoosePlayerNames)
            .playerNames
            .map((String name) => Player(name: name))
            .toList();
      }
    }
    pushToStatsScreen(
      context,
      players,
      useOwnRuleSet: (state as ChoosePlayerNames).useOwnRuleSet,
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
