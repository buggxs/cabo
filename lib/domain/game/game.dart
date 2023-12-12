import 'package:cabo/domain/player/data/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  Game({
    required this.players,
  });

  List<Player> players;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  bool get isGameFinished =>
      players.any((Player player) => player.totalPoints >= 100);
}
