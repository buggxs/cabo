import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'round.g.dart';

@JsonSerializable()
class Round extends Equatable {
  const Round({
    required this.round,
    this.points = 0,
    this.hasPenaltyPoints = false,
    this.hasClosedRound = false,
    this.hasPrecisionLanding = false,
  });

  final int round;
  final int points;
  final bool hasPenaltyPoints;
  final bool hasClosedRound;
  final bool hasPrecisionLanding;

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  Map<String, dynamic> toJson() => _$RoundToJson(this);

  String get stringifyJson => jsonEncode(toJson());

  Round copyWith({
    int? round,
    int? points,
    bool? hasPenaltyPoints,
    bool? hasClosedRound,
    bool? hasPrecisionLanding,
  }) {
    return Round(
      round: round ?? this.round,
      points: points ?? this.points,
      hasPenaltyPoints: hasPenaltyPoints ?? this.hasPenaltyPoints,
      hasClosedRound: hasClosedRound ?? this.hasClosedRound,
      hasPrecisionLanding: hasPrecisionLanding ?? this.hasPrecisionLanding,
    );
  }

  @override
  List<Object?> get props => [
        round,
        points,
        hasPenaltyPoints,
        hasClosedRound,
        hasPrecisionLanding,
      ];
}
