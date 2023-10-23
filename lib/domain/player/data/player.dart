import 'package:cabo/domain/round/round.dart';

class Player {
  const Player({
    required this.name,
    this.place,
    this.rounds = const <Round>[],
  });

  final String name;
  final int? place;
  final List<Round> rounds;

  int get totalPoints {
    if (rounds.isEmpty) {
      return 0;
    }

    if (rounds.length == 1) {
      return rounds.first.points;
    }

    return rounds
        .map((Round round) => round.points)
        .reduce((pointsA, pointsB) => pointsA + pointsB);
  }
}
