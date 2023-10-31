import 'package:cabo/domain/player/data/mock_player_data.dart';
import 'package:cabo/domain/player/data/player.dart';

abstract class PlayerService {
  Future<List<Player>> getPlayers();
}

class LocalPlayerService implements PlayerService {
  @override
  Future<List<Player>> getPlayers() {
    return Future.value(MOCK_PLAYER_LIST);
  }
}
