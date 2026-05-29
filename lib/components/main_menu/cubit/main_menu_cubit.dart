import 'package:bloc/bloc.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/screens/join_game_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/player_group/data/player_group.dart';
import 'package:cabo/domain/player_group/local_player_group_repository.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    final List<PlayerGroup> recentGroups =
        await app<LocalPlayerGroupRepository>().getAll() ?? <PlayerGroup>[];
    emit(ChoosePlayers(recentGroups: recentGroups));
  }

  void showChoosePlayerScreen() {
    checkForPossibleGame();
  }

  Future<void> startGame(List<String> names) async {
    final List<String> cleanedNames = names
        .map((String name) => name.trim())
        .where((String name) => name.isNotEmpty)
        .toList();

    final List<Player> players = cleanedNames
        .map((String name) => Player(name: name))
        .toList();

    bool? shouldUseSpecialRules;
    if (state is ChoosePlayers) {
      shouldUseSpecialRules = (state as ChoosePlayers).shouldUseSpecialRules;
    }

    await _saveRecentGroup(cleanedNames);

    _pushToStatsScreen(players, shouldUseSpecialRules: shouldUseSpecialRules);
  }

  Future<void> _saveRecentGroup(List<String> names) async {
    if (names.isEmpty) {
      return;
    }
    final LocalPlayerGroupRepository repository =
        app<LocalPlayerGroupRepository>();
    final List<PlayerGroup> groups =
        await repository.getAll() ?? <PlayerGroup>[];

    groups.removeWhere(
      (PlayerGroup group) => listEquals(group.playerNames, names),
    );
    groups.insert(0, PlayerGroup(playerNames: names));

    await repository.saveAll(groups.take(5).toList());
  }

  Future<bool> onWillPop() async {
    if (state is ChoosePlayers) {
      emit(MainMenu());
      return false;
    }
    return false;
  }
}
