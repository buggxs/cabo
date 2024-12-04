import 'package:bloc/bloc.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:equatable/equatable.dart';

part 'game_history_state.dart';

class GameHistoryCubit extends Cubit<GameHistoryState> {
  GameHistoryCubit() : super(const GameHistoryState());

  Future<void> loadGames() async {
    List<Game> games = await app<GameService>().getGames() ?? <Game>[];

    emit(state.copyWith(games: games.reversed.toList()));
  }
}
