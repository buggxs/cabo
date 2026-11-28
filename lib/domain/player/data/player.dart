import 'dart:convert';
import 'dart:math';

import 'package:cabo/domain/round/round.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player extends Equatable {
  // Rounds saved before the deduction was stored per round used this value.
  static const int _legacyPrecisionLandingDeduction = 50;

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
    int total = 0;
    for (final Round round in rounds) {
      total += round.points - _precisionLandingDeduction(round);
    }
    return total;
  }

  int _precisionLandingDeduction(Round round) {
    if (!round.hasPrecisionLanding) {
      return 0;
    }
    return round.precisionLandingDeduction ?? _legacyPrecisionLandingDeduction;
  }

  bool hasRoundWinStreak(int streakLength) {
    if (streakLength <= 0) {
      return false;
    }
    if (rounds.length < streakLength) {
      return false;
    }

    int currentStreak = 0;
    // Sort rounds by round number to ensure correct order for streak check
    final List<Round> sortedRounds = List<Round>.from(rounds)
      ..sort((Round a, Round b) => a.round.compareTo(b.round));

    for (final Round round in sortedRounds) {
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

  int get longestRoundWinStreak {
    if (rounds.isEmpty) {
      return 0;
    }

    int maxStreak = 0;
    int currentStreak = 0;
    // Sort rounds by round number to ensure correct order for streak check
    final List<Round> sortedRounds = List<Round>.from(rounds)
      ..sort((Round a, Round b) => a.round.compareTo(b.round));

    for (final Round round in sortedRounds) {
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

  Player copyWith({int? id, String? name, int? place, List<Round>? rounds}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      place: place ?? this.place,
      rounds: rounds ?? this.rounds,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, place, rounds, totalPoints];
}
