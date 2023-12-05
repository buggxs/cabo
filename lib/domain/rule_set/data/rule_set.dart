import 'package:equatable/equatable.dart';

class RuleSet extends Equatable {
  const RuleSet({
    this.totalGamePoints = 100,
    this.kamikazePoints = 50,
    this.roundWinnerGetsZeroPoints = true,
    this.precisionLanding = true,
  });

  final int totalGamePoints;
  final int? kamikazePoints;

  final bool roundWinnerGetsZeroPoints;
  final bool precisionLanding;

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
