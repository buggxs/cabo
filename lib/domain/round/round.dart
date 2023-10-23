class Round {
  const Round({
    required this.round,
    this.points = 0,
    this.hasPenaltyPoints = false,
  });

  final int round;
  final int points;
  final bool hasPenaltyPoints;

  Round copyWith({
    int? round,
    int? points,
    bool? hasPenaltyPoints,
  }) {
    return Round(
      round: round ?? this.round,
      points: points ?? this.points,
      hasPenaltyPoints: hasPenaltyPoints ?? this.hasPenaltyPoints,
    );
  }
}
