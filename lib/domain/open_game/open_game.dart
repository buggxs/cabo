import 'package:cabo/domain/game/game.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'open_game.g.dart';

@JsonSerializable()
class OpenGame extends Equatable {
  const OpenGame({
    this.id,
    required this.game,
    this.gameId,
    this.publicId,
  });

  final int? id;
  final String? publicId;
  final int? gameId;
  final Game game;

  factory OpenGame.fromJson(Map<String, dynamic> json) =>
      _$OpenGameFromJson(json);

  Map<String, dynamic> toJson() => _$OpenGameToJson(this);

  OpenGame copyWith({
    int? id,
    String? publicId,
    int? gameId,
    Game? game,
  }) {
    return OpenGame(
      id: id ?? this.id,
      publicId: publicId ?? this.publicId,
      gameId: gameId ?? this.gameId,
      game: game ?? this.game,
    );
  }

  @override
  List<Object?> get props => [
        id,
        game,
        publicId,
        gameId,
      ];
}
