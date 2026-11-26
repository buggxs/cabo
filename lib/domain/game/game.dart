import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:equatable/equatable.dart';
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
    this.playerUids = const <String>[],
    this.seatingOrder = const <String>[],
  });

  final int? id;
  final String? ownerId;
  final String? publicId;
  final String? startedAt;
  final String? finishedAt;
  final List<Player> players;
  final int? ruleSetId;
  final RuleSet ruleSet;
  final List<String> playerUids;

  // Unlike [players], this list is never re-sorted by placement and therefore
  // drives the dealer rotation.
  final List<String> seatingOrder;

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
    List<String>? playerUids,
    List<String>? seatingOrder,
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
      playerUids: playerUids ?? this.playerUids,
      seatingOrder: seatingOrder ?? this.seatingOrder,
    );
  }

  bool get isPublic => publicId != null && ownerId != null;

  // Falls back to the current player order for games saved before the
  // seating order was introduced.
  List<String> get dealerRotation => seatingOrder.isNotEmpty
      ? seatingOrder
      : players.map((Player player) => player.name).toList();

  // Rotates through [dealerRotation], independent of the current placement.
  String? get currentDealerName {
    final List<String> rotation = dealerRotation;
    if (rotation.isEmpty || players.isEmpty) {
      return null;
    }
    return rotation[playedRounds % rotation.length];
  }

  int get playedRounds => players.isEmpty ? 0 : players.first.rounds.length;

  bool get hasRounds =>
      players.any((Player player) => player.rounds.isNotEmpty);

  Duration? get duration {
    final DateTime? startedDate = _parseDate(startedAt);
    final DateTime? finishedDate = finishedAt == null
        ? DateTime.now()
        : _parseDate(finishedAt);
    if (startedDate == null || finishedDate == null) {
      return null;
    }
    return finishedDate.difference(startedDate);
  }

  DateTime? _parseDate(String? date) {
    return date == null ? null : DateFormat().parseCaboDateString(date);
  }

  String dateToString() {
    if (startedAt == null) {
      return '';
    }

    final DateTime? startedDate = DateFormat().parseCaboDateString(startedAt!);

    if (startedDate == null) {
      return '';
    }

    return DateFormat('dd-MM-yyyy').format(startedDate);
  }

  // Only the highest tier per category is returned.
  List<GameStreakType> getGameStreakTypes() {
    final List<GameStreakType> streaks = <GameStreakType>[];

    if (_hasWonFiveRoundsInARow) {
      GameStreakType winStreak = GameStreakType.fiveRoundsWon;
      if (players.any((Player player) => player.hasRoundWinStreak(7))) {
        winStreak = GameStreakType.sevenRoundsWon;
      }
      if (players.any((Player player) => player.hasRoundWinStreak(10))) {
        winStreak = GameStreakType.tenRoundsWon;
      }
      streaks.add(winStreak);
    }

    if (_isLongerThan(const Duration(hours: 1))) {
      GameStreakType durationStreak = GameStreakType.oneHourGame;
      if (_isLongerThan(const Duration(hours: 1, minutes: 30))) {
        durationStreak = GameStreakType.oneAndHalfHoursGame;
      }
      if (_isLongerThan(const Duration(hours: 2))) {
        durationStreak = GameStreakType.twoHoursGame;
      }
      streaks.add(durationStreak);
    }

    return streaks;
  }

  bool get _hasWonFiveRoundsInARow =>
      players.any((Player player) => player.hasRoundWinStreak(5));

  bool _isLongerThan(Duration streakDuration) {
    if (startedAt == null || finishedAt == null) {
      return false;
    }
    final DateTime? dateStartedAt = DateFormat().parseCaboDateString(
      startedAt!,
    );
    final DateTime? dateFinishedAt = DateFormat().parseCaboDateString(
      finishedAt!,
    );
    if (dateStartedAt == null || dateFinishedAt == null) {
      return false;
    }

    if (dateFinishedAt.isBefore(dateStartedAt)) {
      return false;
    }

    final Duration duration = dateFinishedAt.difference(dateStartedAt);
    return duration.compareTo(streakDuration) >= 0;
  }

  // With precision landing enabled, hitting the total game points exactly
  // halves the score instead of ending the game; only exceeding it does.
  bool get isGameFinished =>
      players.any(
        (Player player) => ruleSet.hasPrecisionLanding
            ? player.totalPoints > ruleSet.totalGamePoints
            : player.totalPoints >= ruleSet.totalGamePoints,
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
    playerUids,
    seatingOrder,
  ];
}
