// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
      round: json['round'] as int,
      points: json['points'] as int? ?? 0,
      hasPenaltyPoints: json['hasPenaltyPoints'] as bool? ?? false,
      hasClosedRound: json['hasClosedRound'] as bool? ?? false,
    );

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
      'round': instance.round,
      'points': instance.points,
      'hasPenaltyPoints': instance.hasPenaltyPoints,
      'hasClosedRound': instance.hasClosedRound,
    };
