import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'round.g.dart';

@JsonSerializable()
class Round extends Equatable {
  const Round({
    this.id,
    required this.round,
    this.points = 0,
    this.hasPenaltyPoints = false,
    this.hasClosedRound = false,
    this.hasPrecisionLanding = false,
    this.precisionLandingDeduction,
    this.isKamikazeRound = false,
    this.isWonRound = false,
  });

  final int? id;
  final int round;
  final int points;
  final bool hasPenaltyPoints;
  final bool hasClosedRound;
  final bool hasPrecisionLanding;

  /// Points subtracted from the total for a precision landing in this round.
  /// `null` on rounds stored before the deduction became rule set dependent;
  /// those fall back to the former fixed deduction of 50 points.
  final int? precisionLandingDeduction;

  /// Marks every player's round of a round that was decided by a kamikaze,
  /// so the score table can tell it apart from an ordinary high hand.
  final bool isKamikazeRound;

  final bool isWonRound;

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  Map<String, dynamic> toJson() => _$RoundToJson(this);

  String get stringifyJson => jsonEncode(toJson());

  Round copyWith({
    int? round,
    int? points,
    bool? hasPenaltyPoints,
    bool? hasClosedRound,
    bool? hasPrecisionLanding,
    int? precisionLandingDeduction,
    bool? isKamikazeRound,
    bool? isWonRound,
  }) {
    return Round(
      round: round ?? this.round,
      points: points ?? this.points,
      hasPenaltyPoints: hasPenaltyPoints ?? this.hasPenaltyPoints,
      hasClosedRound: hasClosedRound ?? this.hasClosedRound,
      hasPrecisionLanding: hasPrecisionLanding ?? this.hasPrecisionLanding,
      precisionLandingDeduction:
          precisionLandingDeduction ?? this.precisionLandingDeduction,
      isKamikazeRound: isKamikazeRound ?? this.isKamikazeRound,
      isWonRound: isWonRound ?? this.isWonRound,
    );
  }

  @override
  List<Object?> get props => [
    id,
    round,
    points,
    hasPenaltyPoints,
    hasClosedRound,
    hasPrecisionLanding,
    precisionLandingDeduction,
    isKamikazeRound,
    isWonRound,
  ];
}
