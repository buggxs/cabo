import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  Game({
    this.finishedAt,
    this.startedAt,
    required this.players,
    required this.ruleSet,
  });

  DateTime? startedAt;
  DateTime? finishedAt;
  List<Player> players;
  RuleSet ruleSet;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    DateTime? startedAt,
    DateTime? finishedAt,
    List<Player>? players,
    RuleSet? ruleSet,
  }) {
    return Game(
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

  bool get isGameFinished =>
      players.any((Player player) => player.totalPoints >= 100);
}
