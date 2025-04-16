import 'dart:convert';
import 'dart:math';

import 'package:cabo/domain/round/round.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player extends Equatable {
  const Player({
    this.id,
    required this.name,
    this.place,
    this.rounds = const <Round>[],
  });

  final int? id;
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

  /// Checks if the player has won at least [streakLength] rounds consecutively
  /// within this game, based on the `isWonRound` flag of their rounds.
  ///
  /// Assumes the `rounds` list is ordered chronologically by round number.
  /// If order is not guaranteed, sorting would be needed first.
  ///
  /// Example: `player.hasRoundWinStreak(5)` checks for a 5-round win streak.
  bool hasRoundWinStreak(int streakLength) {
    if (streakLength <= 0) {
      return false;
    }
    if (rounds.length < streakLength) {
      return false;
    }

    int currentStreak = 0;
    // Sort rounds by round number to ensure correct order for streak check
    final sortedRounds = List<Round>.from(rounds)
      ..sort((a, b) => a.round.compareTo(b.round));

    for (final round in sortedRounds) {
      if (round.isWonRound) {
        currentStreak++;
        if (currentStreak >= streakLength) {
          return true;
        }
      } else {
        currentStreak = 0;
      }
    }

    return false;
  }

  /// Finds the longest consecutive round win streak for the player in this game.
  /// Returns 0 if no rounds were won.
  int get longestRoundWinStreak {
    if (rounds.isEmpty) {
      return 0;
    }

    int maxStreak = 0;
    int currentStreak = 0;
    // Sort rounds by round number to ensure correct order for streak check
    final sortedRounds = List<Round>.from(rounds)
      ..sort((a, b) => a.round.compareTo(b.round));

    for (final round in sortedRounds) {
      if (round.isWonRound) {
        currentStreak++;
      } else {
        maxStreak = max(maxStreak, currentStreak);
        currentStreak = 0;
      }
    }
    maxStreak = max(maxStreak, currentStreak);

    return maxStreak;
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
        id,
        name,
        place,
        rounds,
        totalPoints,
      ];
}
