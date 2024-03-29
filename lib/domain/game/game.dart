import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game extends Equatable {
  const Game({
    this.id,
    this.finishedAt,
    this.startedAt,
    required this.players,
    required this.ruleSet,
  });

  final int? id;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final List<Player> players;
  final RuleSet ruleSet;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? finishedAt,
    List<Player>? players,
    RuleSet? ruleSet,
  }) {
    return Game(
      id: id ?? this.id,
      finishedAt: finishedAt ?? this.finishedAt,
      startedAt: startedAt ?? this.startedAt,
      players: players ?? this.players,
      ruleSet: ruleSet ?? this.ruleSet,
    );
  }

  String get gameDuration {
    if (startedAt != null && finishedAt != null) {
      Duration duration = finishedAt!.difference(startedAt!);
      String durationString = duration.toString().split('.').first;

      return durationString;
    }
    return '';
  }

  String date(String locale) =>
      startedAt != null ? DateFormat.yMd(locale).format(startedAt!) : '';

  bool get isGameFinished => players.any(
        (Player player) => player.totalPoints > ruleSet.totalGamePoints,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        startedAt,
        finishedAt,
        players,
        ruleSet,
      ];
}
