import 'dart:convert';

import 'package:cabo/domain/round/round.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player extends Equatable {
  const Player({
    required this.name,
    this.place,
    this.rounds = const <Round>[],
  });

  final String name;
  final int? place;
  final List<Round> rounds;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  String get stringifyJson => jsonEncode(toJson());

  int get totalPoints {
    if (rounds.isEmpty) {
      return 0;
    }

    if (rounds.length == 1) {
      return rounds.first.points;
    }

    int precisionLandingRounds = rounds
            .where((Round round) => round.hasPrecisionLanding)
            .toList()
            .length *
        -50;

    return rounds
            .map((Round round) => round.points)
            .reduce((pointsA, pointsB) => pointsA + pointsB) +
        precisionLandingRounds;
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
