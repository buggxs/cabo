import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rule_set.g.dart';

@JsonSerializable()
class RuleSet extends Equatable {
  const RuleSet({
    this.id,
    this.totalGamePoints = 100,
    this.kamikazePoints = 50,
    this.roundWinnerGetsZeroPoints = true,
    this.precisionLanding = true,
  });

  final int? id;

  final int totalGamePoints;
  final int? kamikazePoints;

  final bool roundWinnerGetsZeroPoints;
  final bool precisionLanding;

  factory RuleSet.fromJson(Map<String, dynamic> json) =>
      _$RuleSetFromJson(json);

  Map<String, dynamic> toJson() => _$RuleSetToJson(this);

  bool get useKamikazeRule => kamikazePoints != null || kamikazePoints == -1;

  RuleSet copyWith({
    int? totalGamePoints,
    int? kamikazePoints,
    bool? roundWinnerGetsZeroPoints,
    bool? precisionLanding,
  }) {
    return RuleSet(
      totalGamePoints: totalGamePoints ?? this.totalGamePoints,
      kamikazePoints: kamikazePoints ?? this.kamikazePoints,
      roundWinnerGetsZeroPoints:
          roundWinnerGetsZeroPoints ?? this.roundWinnerGetsZeroPoints,
      precisionLanding: precisionLanding ?? this.precisionLanding,
    );
  }

  @override
  List<Object?> get props => [
        id,
        totalGamePoints,
        kamikazePoints,
        roundWinnerGetsZeroPoints,
        precisionLanding,
      ];
}

const RuleSet kOwnRuleSet = RuleSet(
  totalGamePoints: 100,
  kamikazePoints: -1,
  roundWinnerGetsZeroPoints: false,
  precisionLanding: false,
);
