// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      id: (json['id'] as num?)?.toInt(),
      finishedAt: json['finishedAt'] as String?,
      startedAt: json['startedAt'] as String?,
      ruleSetId: (json['ruleSetId'] as num?)?.toInt(),
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      ruleSet: RuleSet.fromJson(json['ruleSet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'id': instance.id,
      'startedAt': instance.startedAt,
      'finishedAt': instance.finishedAt,
      'players': instance.players,
      'ruleSetId': instance.ruleSetId,
      'ruleSet': instance.ruleSet,
    };
