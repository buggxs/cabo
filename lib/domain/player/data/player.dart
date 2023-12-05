import 'package:cabo/domain/round/round.dart';
import 'package:equatable/equatable.dart';

class Player extends Equatable {
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

  Player copyWith({
    String? name,
    int? place,
    List<Round>? rounds,
  }) {
    return Player(
      name: name ?? this.name,
      place: place ?? this.place,
      rounds: rounds ?? this.rounds,
    );
  }

  @override
  List<Object?> get props => [
        name,
        place,
        rounds,
        totalPoints,
      ];
}
