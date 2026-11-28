// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleSet _$RuleSetFromJson(Map<String, dynamic> json) => RuleSet(
  id: (json['id'] as num?)?.toInt(),
  totalGamePoints: (json['totalGamePoints'] as num?)?.toInt() ?? 100,
  kamikazePoints: (json['kamikazePoints'] as num?)?.toInt() ?? 50,
  shouldRoundWinnerGetZeroPoints:
      json['roundWinnerGetsZeroPoints'] as bool? ?? true,
  hasPrecisionLanding: json['precisionLanding'] as bool? ?? true,
);

Map<String, dynamic> _$RuleSetToJson(RuleSet instance) => <String, dynamic>{
  'id': instance.id,
  'totalGamePoints': instance.totalGamePoints,
  'kamikazePoints': instance.kamikazePoints,
  'roundWinnerGetsZeroPoints': instance.shouldRoundWinnerGetZeroPoints,
  'precisionLanding': instance.hasPrecisionLanding,
};
