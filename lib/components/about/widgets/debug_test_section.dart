import 'dart:math';

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/statistics/screens/end_game_screen.dart';
import 'package:cabo/components/statistics/screens/statistics_screen.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/announcement/announcement_check_service.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Spezifikation einer Debug-Runde: Index des Cabo-Ansagers, Index des Spielers
/// mit Strafpunkten (-1 = keiner), Indizes der Rundengewinner, die bereits
/// verrechneten Punkte je Spieler und ob die Runde ein Kamikaze war.
typedef _DebugRoundSpec = ({
  int closer,
  int penalty,
  List<int> winners,
  List<int> points,
  bool kamikaze,
});

/// Debug-only Testbereich am Ende des About-Screens. Bündelt Buttons, mit denen
/// sich bestimmte Bereiche/Screens mit synthetischen Daten direkt aufrufen
/// lassen. Wird ausschließlich im Debug-Build (`kDebugMode`) eingebunden.
class DebugTestSection extends StatelessWidget {
  const DebugTestSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.m3Error.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.bug_report_outlined,
                color: CaboTheme.m3Error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'DEBUG / TEST',
                style: CaboTheme.labelLargeStyle.copyWith(
                  color: CaboTheme.m3Error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DebugButton(
            label: 'Endscreen: fertiges Spiel (3 Spieler, 19 Runden)',
            icon: Icons.emoji_events_outlined,
            onPressed: () => Navigator.of(context).pushNamed(
              EndGameScreen.route,
              arguments: <String, dynamic>{'game': _buildSampleFinishedGame()},
            ),
          ),
          _DebugButton(
            label: 'Laufendes Spiel (4 Spieler, 15 Runden, alle Regelfälle)',
            icon: Icons.sports_esports_outlined,
            onPressed: () => _openRunningGame(context),
          ),
          _DebugButton(
            label: 'Game History mit Testdaten füllen (überschreibt)',
            icon: Icons.history,
            onPressed: () => _fillGameHistory(context),
          ),
          _DebugButton(
            label: 'Announcement-Dialog anzeigen',
            icon: Icons.campaign_outlined,
            onPressed: () => _showAnnouncement(context),
          ),
        ],
      ),
    );
  }

  /// Öffnet den Statistik-Screen mit einem laufenden Testspiel. Das Schließen
  /// einer weiteren Runde überschreibt das zuletzt gespielte Spiel.
  void _openRunningGame(BuildContext context) {
    final Game game = _buildRunningSampleGame();

    Navigator.of(context).pushNamed(
      StatisticsScreen.route,
      arguments: <String, dynamic>{'players': game.players, 'game': game},
    );
  }

  Future<void> _showAnnouncement(BuildContext context) async {
    final bool wasShown = await app<AnnouncementCheckService>()
        .forceShowAnnouncement();

    if (!context.mounted || wasShown) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Es ist aktuell kein Announcement konfiguriert.'),
      ),
    );
  }

  /// Erzeugt einen Satz synthetischer, abgeschlossener Spiele, speichert sie als
  /// Spielhistorie (überschreibt vorhandene) und öffnet den History-Screen.
  Future<void> _fillGameHistory(BuildContext context) async {
    final List<Game> games = _buildSampleHistoryGames();
    await app<GameService>().saveGames(games);

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Game History gefüllt: ${games.length} Spiele')),
    );
    Navigator.of(context).pushNamed(GameHistoryScreen.route);
  }

  /// Baut eine deterministische Liste abgeschlossener Spiele mit
  /// unterschiedlicher Spielerzahl (2–5), verteilt auf mehrere Tage und mit
  /// diversen Streaks (Siegesserien 5/7/10 sowie Spieldauer 1/1,5/2 h). Der
  /// jeweils letztplatzierte Spieler überschreitet immer die 100 Punkte
  /// (Spielende), die übrigen liegen darunter.
  List<Game> _buildSampleHistoryGames() {
    final Random rng = Random(7);

    // (Tag, Startstunde, Dauer in Min, Spielernamen, Rundenzahl,
    //  Streak-Spieler-Index (-1 = keiner), Streak-Länge)
    final List<(String, int, int, List<String>, int, int, int)>
    specs = <(String, int, int, List<String>, int, int, int)>[
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

    final List<Game> games = <Game>[];
    for (int i = 0; i < specs.length; i++) {
      final (String, int, int, List<String>, int, int, int) spec = specs[i];
      games.add(
        _buildHistoryGame(
          id: i + 1,
          day: spec.$1,
          startHour: spec.$2,
          durationMinutes: spec.$3,
          names: spec.$4,
          roundCount: spec.$5,
          streakPlayer: spec.$6,
          streakLength: spec.$7,
          rng: rng,
        ),
      );
    }

    // Der GameHistoryCubit zeigt die Spiele umgekehrt an (`games.reversed`).
    // Damit das neueste Spiel (08.02.2026) oben steht, hier umgekehrt speichern.
    return games.reversed.toList();
  }

  /// Baut ein einzelnes abgeschlossenes Spiel. Der Spieler an Index 0 ist der
  /// designierte Verlierer (Punkte 8–15 pro Runde → garantiert > 100 bei
  /// ≥ 13 Runden). [streakPlayer] erhält die ersten [streakLength] Runden als
  /// Siegesrunden in Folge.
  Game _buildHistoryGame({
    required int id,
    required String day,
    required int startHour,
    required int durationMinutes,
    required List<String> names,
    required int roundCount,
    required int streakPlayer,
    required int streakLength,
    required Random rng,
  }) {
    const RuleSet ruleSet = RuleSet();

    List<Player> players = <Player>[];
    for (int p = 0; p < names.length; p++) {
      final bool isLoser = p == 0;
      final bool hasStreak = p == streakPlayer && streakLength > 0;

      final List<Round> rounds = List<Round>.generate(roundCount, (int i) {
        bool won = false;
        int points;
        if (hasStreak && i < streakLength) {
          won = true;
          points = 0;
        } else if (isLoser) {
          points = 8 + rng.nextInt(8); // 8..15
        } else {
          final int r = rng.nextInt(10);
          if (r == 0) {
            won = true;
            points = 0;
          } else {
            points = 2 + rng.nextInt(8); // 2..9
          }
        }
        return Round(
          round: i + 1,
          points: points,
          isWonRound: won,
          hasClosedRound: won,
          hasPenaltyPoints: !won && points > 0 && i % 6 == 0,
        );
      });

      players.add(Player(name: names[p], rounds: rounds));
    }

    // Aufsteigend nach Punkten sortieren und Platzierung setzen (analog Cubit).
    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    final DateFormat fmt = DateFormat('dd-MM-yyyy HH:mm');
    final DateTime start = fmt.parse(
      '$day ${startHour.toString().padLeft(2, '0')}:00',
    );
    final DateTime end = start.add(Duration(minutes: durationMinutes));

    return Game(
      id: id,
      startedAt: fmt.format(start),
      finishedAt: fmt.format(end),
      players: players,
      ruleSet: ruleSet,
    );
  }

  /// Spieler des laufenden Testspiels.
  static const List<String> _runningGamePlayers = <String>[
    'Mia',
    'Tom',
    'Lena',
    'Ben',
  ];

  /// 15 Runden, die jede Regelkonstellation mindestens einmal enthalten:
  /// Ansager gewinnt (1, 2, 6, 7, ...), Ansager verliert mit +5 (3, 5, 8, 10),
  /// Gleichstand mit Sieg des Ansagers (4), zwei Rundengewinner (5), Kamikaze
  /// (13) und dadurch eine Punktlandung auf exakt 100 bei Ben.
  static const List<_DebugRoundSpec> _runningGameRounds = <_DebugRoundSpec>[
    (
      closer: 0,
      penalty: -1,
      winners: [0],
      points: [0, 6, 4, 8],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: [3],
      points: [5, 3, 4, 0],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: 1,
      winners: [2],
      points: [6, 9, 0, 5],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: -1,
      winners: [2],
      points: [3, 5, 0, 6],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: 3,
      winners: [0, 1],
      points: [0, 0, 2, 11],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: [1],
      points: [4, 0, 3, 5],
      kamikaze: false,
    ),
    (
      closer: 0,
      penalty: -1,
      winners: [0],
      points: [0, 2, 3, 4],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: 2,
      winners: [3],
      points: [4, 3, 8, 0],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: [3],
      points: [5, 2, 2, 0],
      kamikaze: false,
    ),
    (
      closer: 0,
      penalty: 0,
      winners: [2],
      points: [9, 3, 0, 6],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: [1],
      points: [2, 0, 2, 2],
      kamikaze: false,
    ),
    (
      closer: 2,
      penalty: -1,
      winners: [2],
      points: [2, 3, 0, 3],
      kamikaze: false,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: [0],
      points: [0, 50, 50, 50],
      kamikaze: true,
    ),
    (
      closer: 1,
      penalty: -1,
      winners: [1],
      points: [4, 0, 3, 5],
      kamikaze: false,
    ),
    (
      closer: 3,
      penalty: -1,
      winners: [3],
      points: [3, 2, 4, 0],
      kamikaze: false,
    ),
  ];

  /// Baut ein laufendes (nicht beendetes) Spiel aus [_runningGameRounds].
  /// Kein Spieler überschreitet die Gesamtpunktzahl, es lassen sich also
  /// weitere Runden schließen und die letzte Runde korrigieren.
  Game _buildRunningSampleGame() {
    const RuleSet ruleSet = RuleSet();

    final List<int> totals = List<int>.filled(_runningGamePlayers.length, 0);
    final List<List<Round>> rounds = List<List<Round>>.generate(
      _runningGamePlayers.length,
      (_) => <Round>[],
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

    List<Player> players = <Player>[
      for (int p = 0; p < _runningGamePlayers.length; p++)
        Player(name: _runningGamePlayers[p], rounds: rounds[p]),
    ];

    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    final DateTime startedAt = DateTime.now().subtract(
      const Duration(minutes: 42),
    );

    return Game(
      startedAt: DateFormat('dd-MM-yyyy HH:mm').format(startedAt),
      players: players,
      ruleSet: ruleSet,
    );
  }

  int _precisionLandingDeduction(RuleSet ruleSet, int totalPointsAfterRound) {
    if (!ruleSet.precisionLanding ||
        totalPointsAfterRound != ruleSet.totalGamePoints) {
      return 0;
    }
    return ruleSet.totalGamePoints ~/ 2;
  }

  /// Baut ein deterministisch erzeugtes, abgeschlossenes Spiel mit 3 Spielern
  /// und je 19 Runden. Der Spieler mit den meisten Punkten überschreitet sicher
  /// `totalGamePoints` (Default 100), sodass das Spiel als beendet gilt.
  Game _buildSampleFinishedGame() {
    const RuleSet ruleSet = RuleSet();
    final Random rng = Random(42);

    List<Round> buildRounds(int base, int range) {
      return List<Round>.generate(19, (int i) {
        final int points = base + rng.nextInt(range);
        // Jede 6. Runde als Straf-Runde markieren, damit die Detailwerte
        // auch Straf-Punkte zur Anzeige bringen.
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

    // base/range so gewählt, dass „Lena" garantiert über 100 Punkte landet.
    List<Player> players = <Player>[
      Player(name: 'Mia', rounds: buildRounds(0, 5)),
      Player(name: 'Tom', rounds: buildRounds(2, 7)),
      Player(name: 'Lena', rounds: buildRounds(6, 7)),
    ];

    // Aufsteigend nach Punkten sortieren und Platzierung setzen (analog Cubit).
    players.sort(
      (Player a, Player b) => a.totalPoints.compareTo(b.totalPoints),
    );
    for (int i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(place: i + 1);
    }

    return Game(
      startedAt: '01-01-2026 18:00',
      finishedAt: '01-01-2026 19:30',
      players: players,
      ruleSet: ruleSet,
    );
  }
}

/// Einheitlicher Button-Stil für den Debug-Bereich (untereinander aufgereiht).
class _DebugButton extends StatelessWidget {
  const _DebugButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: CaboTheme.m3Error,
          alignment: Alignment.centerLeft,
          side: BorderSide(color: CaboTheme.m3Error.withValues(alpha: 0.4)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          ),
        ),
        icon: Icon(icon, size: 18, color: CaboTheme.m3Error),
        label: Text(
          label,
          style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.m3Error),
        ),
      ),
    );
  }
}
