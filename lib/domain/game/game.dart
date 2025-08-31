import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game extends Equatable {
  const Game({
    this.id,
    this.ownerId,
    this.publicId,
    this.finishedAt,
    this.startedAt,
    this.ruleSetId,
    required this.players,
    required this.ruleSet,
  });

  final int? id;
  final String? ownerId;
  final String? publicId;
  final String? startedAt;
  final String? finishedAt;
  final List<Player> players;
  final int? ruleSetId;
  final RuleSet ruleSet;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    int? id,
    String? ownerId,
    String? publicId,
    String? startedAt,
    String? finishedAt,
    List<Player>? players,
    int? ruleSetId,
    RuleSet? ruleSet,
  }) {
    return Game(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      publicId: publicId ?? this.publicId,
      finishedAt: finishedAt ?? this.finishedAt,
      startedAt: startedAt ?? this.startedAt,
      players: players ?? this.players,
      ruleSetId: ruleSetId ?? this.ruleSetId,
      ruleSet: ruleSet ?? this.ruleSet,
    );
  }

  bool get isPublic => publicId != null && ownerId != null;

  String get gameDuration {
    BuildContext context =
        app<NavigationService>().navigatorKey.currentContext!;
    if (startedAt != null && finishedAt != null) {
      DateTime? dateStartedAt = DateFormat().parseCaboDateString(startedAt!);
      DateTime? dateFinishedAt = DateFormat().parseCaboDateString(finishedAt!);
      if (dateStartedAt == null || dateFinishedAt == null) {
        return '';
      }
      Duration duration = dateFinishedAt.difference(dateStartedAt);
      return '${duration.inHours.remainder(60).toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.historyScreenHours}, '
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.historyScreenMinutes}';
    } else if (startedAt != null && finishedAt == null) {
      DateTime? dateStartedAt = DateFormat().parseCaboDateString(startedAt!);
      DateTime dateFinishedAt = DateTime.now();
      if (dateStartedAt == null) {
        return '';
      }
      Duration duration = dateFinishedAt.difference(dateStartedAt);
      return '${duration.inHours.remainder(60).toString().padLeft(2, '0')}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    }
    return '';
  }

  String dateToString() {
    if (startedAt == null) {
      return '';
    }

    DateTime? startedDate = DateFormat().parseCaboDateString(startedAt!);

    if (startedDate == null) {
      return '';
    }

    return DateFormat('dd-MM-yyyy').format(startedDate);
  }

  List<GameStreak> getGameStreaks() {
    List<GameStreakType> streaks = <GameStreakType>[];

    if (_hasWonFiveRoundsInARow) {
      GameStreakType winStreak = GameStreakType.fiveRoundsWon;
      if (players.any((Player player) => player.hasRoundWinStreak(7))) {
        winStreak = GameStreakType.sevenRoundsWon;
      }
      if (players.any((Player player) => player.hasRoundWinStreak(10))) {
        winStreak = GameStreakType.tenRoundsWon;
      }
      streaks.add(
        winStreak,
      );
    }

    if (_isLongerThan(const Duration(hours: 1))) {
      GameStreakType winStreak = GameStreakType.oneHourGame;
      if (_isLongerThan(const Duration(hours: 1, minutes: 30))) {
        winStreak = GameStreakType.oneAndHalfHoursGame;
      }
      if (_isLongerThan(const Duration(hours: 2))) {
        winStreak = GameStreakType.twoHoursGame;
      }
      streaks.add(winStreak);
    }

    return streaks.map((GameStreakType streak) => streak.streak!).toList();
  }

  bool get _hasWonFiveRoundsInARow =>
      players.any((Player player) => player.hasRoundWinStreak(5));

  bool _isLongerThan(Duration streakDuration) {
    if (startedAt == null || finishedAt == null) {
      return false;
    }
    DateTime? dateStartedAt = DateFormat().parseCaboDateString(startedAt!);
    DateTime? dateFinishedAt = DateFormat().parseCaboDateString(finishedAt!);
    if (dateStartedAt == null || dateFinishedAt == null) {
      return false;
    }

    if (dateFinishedAt.isBefore(dateStartedAt)) {
      return false;
    }

    Duration duration = dateFinishedAt.difference(dateStartedAt);
    return duration.compareTo(streakDuration) >= 0;
  }

  bool get isGameFinished =>
      players.any(
        (Player player) => player.totalPoints > ruleSet.totalGamePoints,
      ) ||
      finishedAt != null;

  @override
  List<Object?> get props => <Object?>[
        id,
        ownerId,
        publicId,
        startedAt,
        finishedAt,
        players,
        ruleSet,
        ruleSetId,
      ];
}
