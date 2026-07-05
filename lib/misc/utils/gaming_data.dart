import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:intl/intl.dart';

int calculatePlayedRounds(List<Game> games) {
  int totalRounds = 0;

  for (Game game in games) {
    if (game.players.isEmpty) continue;
    totalRounds += game.players.first.rounds.length;
  }

  return totalRounds;
}

int calculateTotalPoints(List<Game> games) {
  int totalPoints = 0;

  for (Game game in games) {
    for (Player player in game.players) {
      for (Round round in player.rounds) {
        totalPoints += round.points;
      }
    }
  }

  return totalPoints;
}

/// Summiert die Spieldauer aller Spiele und liefert sie aufgeteilt in
/// `(Tage, Stunden)`. Wird vom Game-History-Screen für die lokalisierte
/// Spielzeit-Karte genutzt.
(int days, int hours) calculateTotalPlayTimeParts(List<Game> games) {
  Duration totalDuration = Duration.zero;

  for (Game game in games) {
    if (game.startedAt != null && game.finishedAt != null) {
      DateTime? start = DateFormat().parseCaboDateString(game.startedAt!);
      DateTime? end = DateFormat().parseCaboDateString(game.finishedAt!);

      if (start != null && end != null && end.isAfter(start)) {
        totalDuration += end.difference(start);
      }
    }
  }

  return (totalDuration.inDays, totalDuration.inHours % 24);
}

String calculateTotalPlayTime(List<Game> games) {
  final (int days, int hours) = calculateTotalPlayTimeParts(games);

  String result = '';
  if (days > 0) {
    result += '$days Days';
  }

  if (result.isNotEmpty) result += '\n';
  result += '$hours Hours';

  return result.isNotEmpty ? result : '0 Hours';
}
