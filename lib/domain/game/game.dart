import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game extends Equatable {
  const Game({
    this.id,
    this.finishedAt,
    this.startedAt,
    this.ruleSetId,
    required this.players,
    required this.ruleSet,
  });

  final int? id;
  final String? startedAt;
  final String? finishedAt;
  final List<Player> players;
  final int? ruleSetId;
  final RuleSet ruleSet;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    int? id,
    String? startedAt,
    String? finishedAt,
    List<Player>? players,
    int? ruleSetId,
    RuleSet? ruleSet,
  }) {
    return Game(
      id: id ?? this.id,
      finishedAt: finishedAt ?? this.finishedAt,
      startedAt: startedAt ?? this.startedAt,
      players: players ?? this.players,
      ruleSetId: ruleSetId ?? this.ruleSetId,
      ruleSet: ruleSet ?? this.ruleSet,
    );
  }

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
      return '${duration.inHours.remainder(60).toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.historyScreenHours}, \n'
          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')} ${AppLocalizations.of(context)!.historyScreenMinutes}';
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

  bool get isGameFinished =>
      players.any(
        (Player player) => player.totalPoints > ruleSet.totalGamePoints,
      ) ||
      finishedAt != null;

  @override
  List<Object?> get props => <Object?>[
        id,
        startedAt,
        finishedAt,
        players,
        ruleSet,
        ruleSetId,
      ];
}
