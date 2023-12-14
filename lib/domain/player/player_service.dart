import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/player/local_player_repository.dart';

abstract class PlayerService {
  Future<List<Player>?> getPlayers();

  Future<void> savePlayers(List<Player> players);
}

class LocalPlayerService implements PlayerService {
  final LocalPlayerRepository localRepository = app<LocalPlayerRepository>();

  @override
  Future<List<Player>?> getPlayers() async {
    return localRepository.getAll();
  }

  @override
  Future<void> savePlayers(List<Player> players) async {
    await localRepository.saveAll(players);
  }
}
