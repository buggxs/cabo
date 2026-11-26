import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/screens/join_game_screen.dart';
import 'package:cabo/components/main_menu/widgets/choose_players.dart';
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

  void pushToScreen(String? route) {
    logger.info('History screen');
    unawaited(
      app<NavigationService>().pushNamed<void>(
        route ?? GameHistoryScreen.route,
      ),
    );
  }

  void showJoinGameDialog() {
    unawaited(
      app<NavigationService>().pushFullscreenDialog<void>(
        const JoinGameScreen(),
      ),
    );
  }

  Future<void> checkForPossibleGame() async {
    final Game? game = await app<GameService>().getLastPlayedGame();
    if (!(game?.isGameFinished ?? true)) {
      final bool? shouldLoadGame = await app<StatisticsDialogService>()
          .loadNotFinishedGame();

      if (shouldLoadGame == null) {
        return;
      }

      if (shouldLoadGame) {
        _pushToStatsScreen(game!.players, game: game);
        return;
      }
    }
    final List<PlayerGroup> recentGroups =
        await app<LocalPlayerGroupRepository>().getAll() ?? <PlayerGroup>[];
    emit(ChoosePlayers(recentGroups: recentGroups));
  }

  void showChoosePlayerScreen() {
    unawaited(checkForPossibleGame());
  }

  Future<void> startGame(List<String> names) async {
    final List<String> cleanedNames = names
        .map((String name) => name.trim())
        .where((String name) => name.isNotEmpty)
        .toList();

    final List<Player> players = cleanedNames
        .map((String name) => Player(name: name))
        .toList();

    // Guard against starting a game without enough players; the UI disables
    // the start button, this protects any programmatic caller.
    if (players.length < ChoosePlayersScreen.minPlayers) {
      return;
    }

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

    final PlayerGroup newGroup = PlayerGroup(playerNames: names);
    groups.removeWhere((PlayerGroup group) => group == newGroup);
    groups.insert(0, newGroup);

    await repository.saveAll(groups.take(5).toList());
  }

  void onWillPop() {
    if (state is ChoosePlayers) {
      emit(MainMenu());
    }
  }
}
