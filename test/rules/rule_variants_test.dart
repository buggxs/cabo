import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_service.dart';
import 'package:cabo/domain/game/local_game_repository.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/local_rule_set_repository.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import 'default_game_rules_test.mocks.dart';

void main() {
  const String bob = 'Bob';
  const String leo = 'Leo';
  const String mia = 'Mia';

  const RuleSet defaultRuleSet = RuleSet();

  final String startedAt = DateFormat(
    'dd-MM-yyyy HH:mm',
  ).format(DateTime.now());

  late MockStatisticsDialogService dialogService;
  late GetIt app = GetIt.instance;

  Player playerWith(String name, List<int> roundPoints) => Player(
    name: name,
    rounds: <Round>[
      for (int i = 0; i < roundPoints.length; i++)
        Round(round: i + 1, points: roundPoints[i]),
    ],
  );

  List<Player> freshPlayers() => <Player>[
    const Player(name: bob),
    const Player(name: leo),
    const Player(name: mia),
  ];

  Player playerNamed(List<Player> players, String name) =>
      players.firstWhere((Player player) => player.name == name);

  Round lastRoundOf(List<Player> players, String name) =>
      playerNamed(players, name).rounds.last;

  Future<StatisticsState> closeRound({
    required List<Player> players,
    required String closer,
    required Map<String, int> points,
    RuleSet ruleSet = defaultRuleSet,
    int? index,
  }) async {
    when(
      dialogService.showRoundCloserDialog(players: anyNamed('players')),
    ).thenAnswer((_) async => playerNamed(players, closer));
    when(
      dialogService.showPointDialog(any, closer: anyNamed('closer')),
    ).thenAnswer((_) async => points);

    final StatisticsCubit cubit = StatisticsCubit(
      players: players,
      game: Game(players: players, ruleSet: ruleSet, startedAt: startedAt),
    );
    final Future<StatisticsState> closedRound = cubit.stream.first;
    cubit.closeRound(index: index);

    final StatisticsState state = await closedRound;
    await cubit.close();
    return state;
  }

  setUpAll(() {
    setup();

    dialogService = MockStatisticsDialogService();

    app.registerSingleton<RuleService>(MockLocalRuleService());
    app.registerSingleton<StatisticsDialogService>(dialogService);
    app.registerSingleton<NavigationService>(MockNavigationService());
    app.registerSingleton<LocalGameRepository>(MockLocalGameRepository());
    app.registerSingleton<GameService>(MockLocalGameService());
    app.registerSingleton<LocalRuleSetRepository>(MockLocalRuleSetRepository());
  });

  tearDownAll(() => app.reset());

  group('Round winner', () {
    test('closing player with the lowest hand wins and scores zero', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 6},
      );

      expect(lastRoundOf(state.players, bob).points, 0);
      expect(lastRoundOf(state.players, bob).isWonRound, isTrue);
      expect(lastRoundOf(state.players, bob).hasClosedRound, isTrue);
      expect(lastRoundOf(state.players, leo).points, 4);
      expect(lastRoundOf(state.players, leo).isWonRound, isFalse);
      expect(lastRoundOf(state.players, mia).points, 6);
    });

    test('on a tie the closing player wins the round', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 4, leo: 4, mia: 6},
      );

      expect(lastRoundOf(state.players, bob).points, 0);
      expect(lastRoundOf(state.players, bob).isWonRound, isTrue);
      expect(lastRoundOf(state.players, leo).points, 4);
      expect(lastRoundOf(state.players, leo).isWonRound, isFalse);
    });

    test('a failed cabo call costs five penalty points', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 8, leo: 3, mia: 6},
      );

      expect(lastRoundOf(state.players, bob).points, 13);
      expect(lastRoundOf(state.players, bob).hasPenaltyPoints, isTrue);
      expect(lastRoundOf(state.players, bob).isWonRound, isFalse);
      expect(lastRoundOf(state.players, leo).points, 0);
      expect(lastRoundOf(state.players, leo).isWonRound, isTrue);
    });

    test('all tied winners score zero when the cabo call fails', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 8, leo: 3, mia: 3},
      );

      expect(lastRoundOf(state.players, bob).points, 13);
      expect(lastRoundOf(state.players, leo).points, 0);
      expect(lastRoundOf(state.players, leo).isWonRound, isTrue);
      expect(lastRoundOf(state.players, mia).points, 0);
      expect(lastRoundOf(state.players, mia).isWonRound, isTrue);
    });

    test('winner keeps the points when the zero rule is disabled', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 6},
        ruleSet: defaultRuleSet.copyWith(roundWinnerGetsZeroPoints: false),
      );

      expect(lastRoundOf(state.players, bob).points, 3);
      expect(lastRoundOf(state.players, bob).isWonRound, isTrue);
      expect(lastRoundOf(state.players, leo).points, 4);
    });

    test('penalty points apply while the zero rule is disabled', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 8, leo: 3, mia: 6},
        ruleSet: defaultRuleSet.copyWith(roundWinnerGetsZeroPoints: false),
      );

      expect(lastRoundOf(state.players, bob).points, 13);
      expect(lastRoundOf(state.players, leo).points, 3);
      expect(lastRoundOf(state.players, leo).isWonRound, isTrue);
    });
  });

  group('Kamikaze', () {
    test('kamikaze player scores zero, everyone else the penalty', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 50},
      );

      expect(lastRoundOf(state.players, mia).points, 0);
      expect(lastRoundOf(state.players, mia).isWonRound, isTrue);
      expect(lastRoundOf(state.players, bob).points, 50);
      expect(lastRoundOf(state.players, bob).isWonRound, isFalse);
      expect(lastRoundOf(state.players, leo).points, 50);
      for (final Player player in state.players) {
        expect(player.rounds.last.isKamikazeRound, isTrue);
      }
    });

    test('penalty follows the configured kamikaze points', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 25},
        ruleSet: defaultRuleSet.copyWith(kamikazePoints: 25),
      );

      expect(lastRoundOf(state.players, mia).points, 0);
      expect(lastRoundOf(state.players, bob).points, 25);
      expect(lastRoundOf(state.players, leo).points, 25);
    });

    test('kamikaze by the closing player leaves no penalty points', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: mia,
        points: <String, int>{bob: 3, leo: 4, mia: 50},
      );

      expect(lastRoundOf(state.players, mia).points, 0);
      expect(lastRoundOf(state.players, mia).isWonRound, isTrue);
      expect(lastRoundOf(state.players, mia).hasPenaltyPoints, isFalse);
      expect(lastRoundOf(state.players, bob).points, 50);
      expect(lastRoundOf(state.players, leo).points, 50);
    });

    test('kamikaze beats the zero rule for the round winner', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 8, leo: 3, mia: 50},
      );

      expect(lastRoundOf(state.players, leo).points, 50);
      expect(lastRoundOf(state.players, leo).isWonRound, isFalse);
      expect(lastRoundOf(state.players, bob).points, 50);
      expect(lastRoundOf(state.players, bob).hasPenaltyPoints, isFalse);
    });

    test('zero kamikaze points disable the rule', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 0, leo: 4, mia: 6},
        ruleSet: defaultRuleSet.copyWith(kamikazePoints: 0),
      );

      expect(lastRoundOf(state.players, bob).points, 0);
      expect(lastRoundOf(state.players, bob).isWonRound, isTrue);
      expect(lastRoundOf(state.players, leo).points, 4);
      expect(lastRoundOf(state.players, mia).points, 6);
      for (final Player player in state.players) {
        expect(player.rounds.last.isKamikazeRound, isFalse);
      }
    });
  });

  group('Precision landing', () {
    test('landing exactly on the limit halves the score', () async {
      final StatisticsState state = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[10, 10]),
          playerWith(leo, <int>[20, 20]),
          playerWith(mia, <int>[40, 40]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 20},
      );

      expect(lastRoundOf(state.players, mia).hasPrecisionLanding, isTrue);
      expect(lastRoundOf(state.players, mia).precisionLandingDeduction, 50);
      expect(playerNamed(state.players, mia).totalPoints, 50);
      expect(state.game?.isGameFinished, isFalse);
    });

    test('deduction scales with the configured total game points', () async {
      final StatisticsState state = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[10, 10]),
          playerWith(leo, <int>[20, 20]),
          playerWith(mia, <int>[50, 50, 50, 30]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 20},
        ruleSet: defaultRuleSet.copyWith(totalGamePoints: 200),
      );

      expect(lastRoundOf(state.players, mia).precisionLandingDeduction, 100);
      expect(playerNamed(state.players, mia).totalPoints, 100);
      expect(state.game?.isGameFinished, isFalse);
    });

    test('landing in the very first round is applied', () async {
      final StatisticsState state = await closeRound(
        players: freshPlayers(),
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 20},
        ruleSet: defaultRuleSet.copyWith(totalGamePoints: 20),
      );

      expect(lastRoundOf(state.players, mia).hasPrecisionLanding, isTrue);
      expect(playerNamed(state.players, mia).totalPoints, 10);
    });

    test('exceeding the limit finishes the game', () async {
      final StatisticsState state = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[10, 10]),
          playerWith(leo, <int>[20, 20]),
          playerWith(mia, <int>[40, 40]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 21},
      );

      expect(lastRoundOf(state.players, mia).hasPrecisionLanding, isFalse);
      expect(playerNamed(state.players, mia).totalPoints, 101);
      expect(state.game?.isGameFinished, isTrue);
    });

    test('without the rule the exact limit finishes the game', () async {
      final StatisticsState state = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[10, 10]),
          playerWith(leo, <int>[20, 20]),
          playerWith(mia, <int>[40, 40]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 20},
        ruleSet: defaultRuleSet.copyWith(precisionLanding: false),
      );

      expect(lastRoundOf(state.players, mia).hasPrecisionLanding, isFalse);
      expect(playerNamed(state.players, mia).totalPoints, 100);
      expect(state.game?.isGameFinished, isTrue);
    });
  });

  group('Correcting the last round', () {
    test('correction keeps the round numbering', () async {
      final StatisticsState state = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[3, 4, 5]),
          playerWith(leo, <int>[6, 7, 8]),
          playerWith(mia, <int>[9, 10, 11]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 6},
        index: 2,
      );

      for (final Player player in state.players) {
        expect(player.rounds.length, 3);
        expect(player.rounds.map((Round round) => round.round), <int>[1, 2, 3]);
      }
      expect(lastRoundOf(state.players, leo).points, 4);
      expect(playerNamed(state.players, leo).totalPoints, 17);
    });

    test('correction recalculates the precision landing', () async {
      final StatisticsState landed = await closeRound(
        players: <Player>[
          playerWith(bob, <int>[10, 10]),
          playerWith(leo, <int>[20, 20]),
          playerWith(mia, <int>[40, 40]),
        ],
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 20},
      );
      expect(playerNamed(landed.players, mia).totalPoints, 50);

      final StatisticsState corrected = await closeRound(
        players: landed.players,
        closer: bob,
        points: <String, int>{bob: 3, leo: 4, mia: 10},
        index: 2,
      );

      expect(lastRoundOf(corrected.players, mia).hasPrecisionLanding, isFalse);
      expect(playerNamed(corrected.players, mia).totalPoints, 90);
    });
  });
}
