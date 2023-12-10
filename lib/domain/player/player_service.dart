import 'package:cabo/domain/player/data/player.dart';

abstract class PlayerService {
  Future<List<Player>> getPlayers();
}

class LocalPlayerService implements PlayerService {
  @override
  Future<List<Player>> getPlayers() {
    // TODO: implement getPlayers
    throw UnimplementedError();
  }
}
