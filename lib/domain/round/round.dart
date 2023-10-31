class Round {
  const Round({
    required this.round,
    this.points = 0,
    this.hasPenaltyPoints = false,
    this.hasClosedRound = false,
  });

  final int round;
  final int points;
  final bool hasPenaltyPoints;
  final bool hasClosedRound;

  Round copyWith({
    int? round,
    int? points,
    bool? hasPenaltyPoints,
    bool? hasClosedRound,
  }) {
    return Round(
      round: round ?? this.round,
      points: points ?? this.points,
      hasPenaltyPoints: hasPenaltyPoints ?? this.hasPenaltyPoints,
      hasClosedRound: hasClosedRound ?? this.hasClosedRound,
    );
  }
}
