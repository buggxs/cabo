import 'dart:math';

import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:intl/intl.dart';

// Debug round: index of the Cabo caller, index of the player with penalty
// points (-1 = none), indices of the round winners, the already settled points
// per player and whether the round was a kamikaze.
typedef _DebugRoundSpec = ({
  int closer,
  int penalty,
  List<int> winners,
  List<int> points,
  bool kamikaze,
});

// (day, start hour, duration in minutes, player names, round count,
//  streak player index (-1 = none), streak length)
typedef _HistoryGameSpec = (String, int, int, List<String>, int, int, int);

/// Deterministic synthetic games for the debug section of the about screen.
class DebugSampleGames {
  const DebugSampleGames._();

  static const List<String> _runningGamePlayers = <String>[
    'Mia',
    'Tom',
    'Lena',
    'Ben',
  ];

  // 15 rounds that contain every rule constellation at least once: caller
  // wins (1, 2, 6, 7, ...), caller loses with +5 (3, 5, 8, 10), tie won by the
  // caller (4), two round winners (5), kamikaze (13) and thereby a precision
  // landing on exactly 100 for Ben.
  static const List<_DebugRoundSpec> _runningGameRounds = <_DebugRoundSpec>[
    (
      closer: 0,
      penalty: -1,
      winners: <int>[0],
      points: <int>[0, 6, 4, 8],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: <int>[3],
      points: <int>[5, 3, 4, 0],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: 1,
      winners: <int>[2],
      points: <int>[6, 9, 0, 5],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: -1,
      winners: <int>[2],
      points: <int>[3, 5, 0, 6],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: 3,
      winners: <int>[0, 1],
      points: <int>[0, 0, 2, 11],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: <int>[1],
      points: <int>[4, 0, 3, 5],
      kamikaze: false,
    ),
    (
      closer: 0,
      penalty: -1,
      winners: <int>[0],
      points: <int>[0, 2, 3, 4],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: 2,
      winners: <int>[3],
      points: <int>[4, 3, 8, 0],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: <int>[3],
      points: <int>[5, 2, 2, 0],
      kamikaze: false,
    ),
    (
      closer: 0,
      penalty: 0,
      winners: <int>[2],
      points: <int>[9, 3, 0, 6],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: <int>[1],
      points: <int>[2, 0, 2, 2],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: -1,
      winners: <int>[2],
      points: <int>[2, 3, 0, 3],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: <int>[0],
      points: <int>[0, 50, 50, 50],
      kamikaze: true,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: <int>[1],
      points: <int>[4, 0, 3, 5],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: <int>[3],
      points: <int>[3, 2, 4, 0],
      kamikaze: false,
    ),
  ];

  static const List<_HistoryGameSpec> _historyGameSpecs = <_HistoryGameSpec>[
    (
      '08-02-2026',
      18,
      130,
      <String>['Michi', 'Pascal', 'Andre', 'Silke', 'Tom'],
      16,
      2,
      10,
    ),
    ('08-02-2026', 21, 95, <String>['Soso', 'Pauline', 'Andre'], 13, 1, 7),
    ('05-02-2026', 19, 70, <String>['Michi', 'Pascal', 'Andre'], 14, 2, 5),
    ('05-02-2026', 21, 45, <String>['Tom', 'Andre'], 13, -1, 0),
    (
      '12-01-2026',
      17,
      105,
      <String>['Soso', 'Silke', 'Pauline', 'Andre'],
      14,
      3,
      5,
    ),
    (
      '12-01-2026',
      20,
      65,
      <String>['Michi', 'Tom', 'Pascal', 'Andre', 'Silke'],
      13,
      4,
      5,
    ),
    ('20-12-2025', 16, 125, <String>['Pascal', 'Andre', 'Michi'], 15, 1, 7),
    ('20-12-2025', 19, 50, <String>['Soso', 'Pauline'], 13, -1, 0),
    (
      '02-11-2025',
      18,
      95,
      <String>['Michi', 'Silke', 'Tom', 'Andre', 'Pascal'],
      14,
      3,
      5,
    ),
    ('02-11-2025', 21, 135, <String>['Pauline', 'Soso', 'Andre'], 16, 2, 10),
  ];

  /// Builds a deterministic list of finished games with different player
  /// counts (2-5), spread over several days and with various streaks (win
  /// streaks 5/7/10 and game durations 1/1.5/2 h). The last placed player
  /// always exceeds 100 points (end of game), the others stay below.
  static List<Game> historyGames() {
    final Random rng = Random(7);

    final List<Game> games = <Game>[
      for (int i = 0; i < _historyGameSpecs.length; i++)
        _buildHistoryGame(id: i + 1, spec: _historyGameSpecs[i], rng: rng),
    ];

    // GameHistoryCubit shows the games reversed (`games.reversed`). Store them
    // reversed here so the newest game (08.02.2026) is on top.
    return games.reversed.toList();
  }

  /// Builds a single finished game. The player at index 0 is the designated
  /// loser (8-15 points per round, so > 100 is guaranteed with >= 13 rounds).
  /// The streak player wins the first rounds of the streak length in a row.
  static Game _buildHistoryGame({
    required int id,
    required _HistoryGameSpec spec,
    required Random rng,
  }) {
    final (
      String day,
      int startHour,
      int durationMinutes,
      List<String> names,
      int roundCount,
      int streakPlayer,
      int streakLength,
    ) = spec;

    final List<Player> players = <Player>[
      for (int p = 0; p < names.length; p++)
        Player(
          name: names[p],
          rounds: _buildHistoryRounds(
            roundCount: roundCount,
            isLoser: p == 0,
            hasStreak: p == streakPlayer && streakLength > 0,
            streakLength: streakLength,
            rng: rng,
          ),
        ),
    ];

    final DateFormat fmt = DateFormat('dd-MM-yyyy HH:mm');
    final DateTime start = fmt.parse(
      '$day ${startHour.toString().padLeft(2, '0')}:00',
    );
    final DateTime end = start.add(Duration(minutes: durationMinutes));

    return Game(
      id: id,
      startedAt: fmt.format(start),
      finishedAt: fmt.format(end),
      players: _withPlaces(players),
      ruleSet: const RuleSet(),
    );
  }

  /// Builds the rounds of one history player. Draws from [rng] in the same
  /// order for every round so the generated data stays deterministic.
  static List<Round> _buildHistoryRounds({
    required int roundCount,
    required bool isLoser,
    required bool hasStreak,
    required int streakLength,
    required Random rng,
  }) {
    return List<Round>.generate(roundCount, (int i) {
      bool isWon = false;
      int points;
      if (hasStreak && i < streakLength) {
        isWon = true;
        points = 0;
      } else if (isLoser) {
        points = 8 + rng.nextInt(8); // 8..15
      } else {
        final int r = rng.nextInt(10);
        if (r == 0) {
          isWon = true;
          points = 0;
        } else {
          points = 2 + rng.nextInt(8); // 2..9
        }
      }
      return Round(
        round: i + 1,
        points: points,
        isWonRound: isWon,
        hasClosedRound: isWon,
        hasPenaltyPoints: !isWon && points > 0 && i % 6 == 0,
      );
    });
  }

  /// Builds a running (unfinished) game from the predefined debug rounds. No
  /// player exceeds the total game points, so further rounds can be closed and
  /// the last round can be corrected.
  static Game runningGame() {
    const RuleSet ruleSet = RuleSet();
    final List<List<Round>> rounds = _buildRunningGameRounds(ruleSet);

    final List<Player> players = <Player>[
      for (int p = 0; p < _runningGamePlayers.length; p++)
        Player(name: _runningGamePlayers[p], rounds: rounds[p]),
    ];

    final DateTime startedAt = DateTime.now().subtract(
      const Duration(minutes: 42),
    );

    return Game(
      startedAt: DateFormat('dd-MM-yyyy HH:mm').format(startedAt),
      players: _withPlaces(players),
      ruleSet: ruleSet,
    );
  }

  /// Returns the rounds per player of the running debug game.
  static List<List<Round>> _buildRunningGameRounds(RuleSet ruleSet) {
    final List<int> totals = List<int>.filled(_runningGamePlayers.length, 0);
    final List<List<Round>> rounds = List<List<Round>>.generate(
      _runningGamePlayers.length,
      (int _) => <Round>[],
    );

    for (int r = 0; r < _runningGameRounds.length; r++) {
      final _DebugRoundSpec spec = _runningGameRounds[r];
      for (int p = 0; p < _runningGamePlayers.length; p++) {
        final int points = spec.points[p];
        final int deduction = _precisionLandingDeduction(
          ruleSet,
          totals[p] + points,
        );

        rounds[p].add(
          Round(
            round: r + 1,
            points: points,
            hasClosedRound: spec.closer == p,
            hasPenaltyPoints: spec.penalty == p,
            hasPrecisionLanding: deduction > 0,
            precisionLandingDeduction: deduction > 0 ? deduction : null,
            isKamikazeRound: spec.kamikaze,
            isWonRound: spec.winners.contains(p),
          ),
        );
        totals[p] += points - deduction;
      }
    }
    return rounds;
  }

  static int _precisionLandingDeduction(
    RuleSet ruleSet,
    int totalPointsAfterRound,
  ) {
    if (!ruleSet.hasPrecisionLanding ||
        totalPointsAfterRound != ruleSet.totalGamePoints) {
      return 0;
    }
    return ruleSet.totalGamePoints ~/ 2;
  }

  /// Builds a deterministic finished game with 3 players and 19 rounds each.
  /// The player with the most points safely exceeds `totalGamePoints`
  /// (default 100), so the game counts as finished.
  static Game finishedGame() {
    final Random rng = Random(42);

    List<Round> buildRounds(int base, int range) {
      return List<Round>.generate(19, (int i) {
        final int points = base + rng.nextInt(range);
        // Mark every 6th round as a penalty round so the detail values also
        // show penalty points.
        final bool hasPenalty = points > 0 && i % 6 == 0;
        return Round(
          round: i + 1,
          points: points,
          isWonRound: points == 0,
          hasClosedRound: points == 0,
          hasPenaltyPoints: hasPenalty,
        );
      });
    }

    // base/range chosen so that "Lena" is guaranteed to end up above 100.
    final List<Player> players = <Player>[
      Player(name: 'Mia', rounds: buildRounds(0, 5)),
      Player(name: 'Tom', rounds: buildRounds(2, 7)),
      Player(name: 'Lena', rounds: buildRounds(6, 7)),
    ];

    return Game(
      startedAt: '01-01-2026 18:00',
      finishedAt: '01-01-2026 19:30',
      players: _withPlaces(players),
      ruleSet: const RuleSet(),
    );
  }

  /// Sorts the players ascending by points and assigns their places, like
  /// the statistics cubit does.
  static List<Player> _withPlaces(List<Player> players) {
    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );
    return <Player>[
      for (int i = 0; i < players.length; i++)
        players[i].copyWith(place: i + 1),
    ];
  }
}
