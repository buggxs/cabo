import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/local_game_repository.dart';

abstract class GameService {
  Future<List<Game>?> getGames();

  Future<void> saveGames(List<Game> games);

  Future<void> saveToGameHistory(Game game);

  Future<Game?> saveGame(Game game);

  Future<Game?> getCurrentGame();
}

class LocalGameService implements GameService {
  final LocalGameRepository localGameRepository = app<LocalGameRepository>();

  @override
  Future<List<Game>?> getGames() async {
    return localGameRepository.getAll();
  }

  @override
  Future<void> saveGames(List<Game> games) async {
    await localGameRepository.saveAll(games);
  }

  @override
  Future<Game?> saveGame(Game game) async {
    return localGameRepository.save(game);
  }

  @override
  Future<void> saveToGameHistory(Game game) async {
    List<Game> games = await getGames() ?? <Game>[];
    int index = games.indexWhere((Game tmpGame) => tmpGame.id == game.id);
    if (index == -1) {
      Game updatedGame = game.copyWith(id: games.length + 1);
      games.add(updatedGame);
      if (!updatedGame.isGameFinished) {
        saveGame(updatedGame);
      }
    } else {
      games[index] = game;
    }
    saveGames(games);
  }

  @override
  Future<Game?> getCurrentGame() {
    return localGameRepository.getCurrent();
  }
}
