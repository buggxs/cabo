// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
  id: (json['id'] as num?)?.toInt(),
  round: (json['round'] as num).toInt(),
  points: (json['points'] as num?)?.toInt() ?? 0,
  hasPenaltyPoints: json['hasPenaltyPoints'] as bool? ?? false,
  hasClosedRound: json['hasClosedRound'] as bool? ?? false,
  hasPrecisionLanding: json['hasPrecisionLanding'] as bool? ?? false,
  isWonRound: json['isWonRound'] as bool? ?? false,
);

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
  'id': instance.id,
  'round': instance.round,
  'points': instance.points,
  'hasPenaltyPoints': instance.hasPenaltyPoints,
  'hasClosedRound': instance.hasClosedRound,
  'hasPrecisionLanding': instance.hasPrecisionLanding,
  'isWonRound': instance.isWonRound,
};
