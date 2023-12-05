import 'package:bloc_test/bloc_test.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/domain/rule_set/rules_service.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statistics_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalRuleService>(),
  MockSpec<StatisticsDialogService>(),
  MockSpec<NavigationService>()
])
void main() {
  List<Player> playerList = [
    const Player(name: 'Kevin'),
    const Player(name: 'Maike'),
    const Player(name: 'Mia'),
  ];

  List<Player> expectedPlayerListWithDefaultRulesAndNoPenalty = [
    const Player(
      name: 'Maike',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 1,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Mia',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Kevin',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMap = {
    playerList[0].name: 3,
    playerList[1].name: 1,
    playerList[2].name: 6,
  };

  late RuleService ruleService;
  late StatisticsDialogService dialogService;
  late NavigationService navigationService;
  late GetIt app = GetIt.instance;

  setUpAll(() {
    setup();

    ruleService = MockLocalRuleService();
    dialogService = MockStatisticsDialogService();
    navigationService = MockNavigationService();

    app.registerSingleton<RuleService>(ruleService);
    app.registerSingleton<StatisticsDialogService>(dialogService);
    app.registerSingleton<NavigationService>(navigationService);
  });

  tearDownAll(() => app.reset());

  group('Test loading rule set', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'load rule set and emit to state',
      setUp: () {
        when(ruleService.loadRuleSet()).thenReturn(const RuleSet());
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [
        StatisticsState(
          ruleSet: const RuleSet(),
          players: playerList,
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should load default rule set with local service',
      setUp: () {
        app.registerSingleton<RuleService>(LocalRuleService());
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [
        StatisticsState(ruleSet: const RuleSet(), players: playerList),
      ],
      tearDown: () {
        app.registerSingleton<RuleService>(ruleService);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should load own rule set with local service',
      setUp: () {
        app.registerSingleton<RuleService>(LocalRuleService());
      },
      build: () => StatisticsCubit(players: playerList, useOwnRuleSet: true),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [
        StatisticsState(
          ruleSet: kOwnRuleSet,
          players: playerList,
        ),
      ],
      tearDown: () {
        app.registerSingleton<RuleService>(ruleService);
      },
    );
  });

  group('Test closing round method', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with default rule set and ZERO players',
      setUp: () {
        when(ruleService.loadRuleSet()).thenReturn(const RuleSet());
      },
      build: () => StatisticsCubit(players: <Player>[]),
      act: (cubit) => cubit
        ..loadRuleSet()
        ..closeRound(),
      expect: () => [
        const StatisticsState(ruleSet: RuleSet(), players: <Player>[]),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with default rule set',
      setUp: () {
        when(ruleService.loadRuleSet()).thenReturn(const RuleSet());
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(dialogService.showPointDialog(playerList))
            .thenAnswer((_) => Future.value(pointsMap));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit
        ..loadRuleSet()
        ..closeRound(),
      expect: () => [
        StatisticsState(ruleSet: const RuleSet(), players: playerList),
        StatisticsState(
          ruleSet: const RuleSet(),
          players: expectedPlayerListWithDefaultRulesAndNoPenalty,
        ),
      ],
    );
  });
}
