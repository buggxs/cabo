import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rule_set.g.dart';

// Added when the player who called Cabo does not have the lowest hand.
const int kFailedCaboPenaltyPoints = 5;

@JsonSerializable()
class RuleSet extends Equatable {
  const RuleSet({
    this.id,
    this.totalGamePoints = 100,
    this.kamikazePoints = 50,
    this.shouldRoundWinnerGetZeroPoints = true,
    this.hasPrecisionLanding = true,
  });

  final int? id;

  final int totalGamePoints;
  final int kamikazePoints;

  @JsonKey(name: 'roundWinnerGetsZeroPoints')
  final bool shouldRoundWinnerGetZeroPoints;
  @JsonKey(name: 'precisionLanding')
  final bool hasPrecisionLanding;

  factory RuleSet.fromJson(Map<String, dynamic> json) =>
      _$RuleSetFromJson(json);

  Map<String, dynamic> toJson() => _$RuleSetToJson(this);

  bool get hasKamikazeRule => kamikazePoints > 0;

  RuleSet copyWith({
    int? totalGamePoints,
    int? kamikazePoints,
    bool? shouldRoundWinnerGetZeroPoints,
    bool? hasPrecisionLanding,
  }) {
    return RuleSet(
      totalGamePoints: totalGamePoints ?? this.totalGamePoints,
      kamikazePoints: kamikazePoints ?? this.kamikazePoints,
      shouldRoundWinnerGetZeroPoints:
          shouldRoundWinnerGetZeroPoints ?? this.shouldRoundWinnerGetZeroPoints,
      hasPrecisionLanding: hasPrecisionLanding ?? this.hasPrecisionLanding,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    totalGamePoints,
    kamikazePoints,
    shouldRoundWinnerGetZeroPoints,
    hasPrecisionLanding,
  ];
}

const RuleSet kOwnRuleSet = RuleSet(
  totalGamePoints: 100,
  kamikazePoints: 0,
  shouldRoundWinnerGetZeroPoints: false,
  hasPrecisionLanding: false,
);
