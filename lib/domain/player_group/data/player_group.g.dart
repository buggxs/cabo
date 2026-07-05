// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerGroup _$PlayerGroupFromJson(Map<String, dynamic> json) => PlayerGroup(
  playerNames: (json['playerNames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$PlayerGroupToJson(PlayerGroup instance) =>
    <String, dynamic>{'playerNames': instance.playerNames};
