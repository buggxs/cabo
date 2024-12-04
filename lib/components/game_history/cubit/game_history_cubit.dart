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

  void sortGamesByDate(List<Game> games) {
    games.sort((a, b) {
      DateTime? dateA =
          a.startedAt != null ? DateTime.tryParse(a.startedAt!) : null;
      DateTime? dateB =
          b.startedAt != null ? DateTime.tryParse(b.startedAt!) : null;

      if (dateA == null && dateB == null)
        return 0; // Beide sind null, gleichwertig
      if (dateA == null) return 1; // `a` ist später, wenn es kein Datum hat
      if (dateB == null) return -1; // `b` ist später, wenn es kein Datum hat

      return dateB.compareTo(dateA); // Jüngeres Datum zuerst
    });
  }
}
