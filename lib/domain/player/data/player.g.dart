// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      name: json['name'] as String,
      place: json['place'] as int?,
      rounds: (json['rounds'] as List<dynamic>?)
              ?.map((e) => Round.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Round>[],
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'place': instance.place,
      'rounds': instance.rounds,
    };
