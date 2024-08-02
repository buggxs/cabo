// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenGame _$OpenGameFromJson(Map<String, dynamic> json) => OpenGame(
      id: (json['id'] as num?)?.toInt(),
      game: Game.fromJson(json['game'] as Map<String, dynamic>),
      gameId: (json['gameId'] as num?)?.toInt(),
      publicId: json['publicId'] as String?,
    );

Map<String, dynamic> _$OpenGameToJson(OpenGame instance) => <String, dynamic>{
      'id': instance.id,
      'publicId': instance.publicId,
      'gameId': instance.gameId,
      'game': instance.game,
    };
