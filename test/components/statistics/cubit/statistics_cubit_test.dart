import 'package:bloc_test/bloc_test.dart';
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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statistics_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalRuleService>(),
  MockSpec<StatisticsDialogService>(),
  MockSpec<NavigationService>(),
  MockSpec<LocalGameRepository>(),
  MockSpec<LocalRuleSetRepository>(),
  MockSpec<LocalGameService>(),
])
void main() {
  List<Player> playerList = [
    const Player(name: 'Kevin'),
    const Player(name: 'Maike'),
    const Player(name: 'Mia'),
  ];

  List<Player> playerListPrecisionLanding = [
    const Player(
      name: 'Mia',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 22,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 3,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: 'Kevin',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 2,
          points: 35,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 25,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Maike',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 20,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 40,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 20,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
  ];

  RuleSet ruleSet = const RuleSet();

  String gameStartedDate = DateFormat(
    'dd-MM-yyyy HH:mm',
  ).format(DateTime.now());

  Game expectedGame = Game(
    players: playerList,
    ruleSet: ruleSet,
    startedAt: gameStartedDate,
  );

  Game expectedPrecisionLandingGame = Game(
    players: playerListPrecisionLanding,
    ruleSet: ruleSet,
    startedAt: gameStartedDate,
  );

  List<Player> expectedPlayerListWithDefaultRulesAndPenalty = [
    const Player(
      name: 'Maike',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
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

  List<Player> expectedPlayerListWithDefaultRules = [
    const Player(
      name: 'Kevin',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: 'Maike',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 4,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Mia',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
  ];

  List<Player> expectedPlayerListWithDefaultRulesHittingKamikaze = [
    const Player(
      name: 'Kevin',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: 'Maike',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Mia',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
  ];

  List<Player> expectedPlayerListWithDefaultRulesPrecisionLanding = [
    const Player(
      name: 'Mia',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 22,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 3,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: 'Maike',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 20,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 40,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 20,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 20,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          hasPrecisionLanding: true,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Kevin',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 2,
          points: 35,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 25,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
  ];

  List<Player> expectedPlayerListWithOwnRules = [
    const Player(
      name: 'Kevin',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: 'Maike',
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 4,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
    const Player(
      name: 'Mia',
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
  ];

  List<Player> expectedPlayerListWithOwnRulesAndPenalty = [
    const Player(
      name: 'Maike',
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 1,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
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

  Map<String, int> pointsMapOwnRulesPenalty = {
    playerList[0].name: 3,
    playerList[1].name: 1,
    playerList[2].name: 6,
  };

  Map<String, int> pointsMapOwnRules = {
    playerList[0].name: 3,
    playerList[1].name: 4,
    playerList[2].name: 6,
  };

  Map<String, int> pointsMapDefaultRulesPenalty = {
    playerList[0].name: 3,
    playerList[1].name: 1,
    playerList[2].name: 6,
  };

  Map<String, int> pointsMapDefaultRules = {
    playerList[0].name: 3,
    playerList[1].name: 4,
    playerList[2].name: 6,
  };

  Map<String, int> pointsMapDefaultRulesKamikaze = {
    playerList[0].name: 50,
    playerList[1].name: 4,
    playerList[2].name: 6,
  };

  Map<String, int> pointsMapDefaultRulesPrecisionLanding = {
    playerListPrecisionLanding[0].name: 6,
    playerListPrecisionLanding[1].name: 11,
    playerListPrecisionLanding[2].name: 20,
  };

  late RuleService ruleService;
  late StatisticsDialogService dialogService;
  late NavigationService navigationService;
  late LocalGameRepository localGameRepository;
  late LocalGameService localGameService;
  late LocalRuleSetRepository localRuleSetRepository;
  late GetIt app = GetIt.instance;

  setUpAll(() {
    setup();

    ruleService = MockLocalRuleService();
    dialogService = MockStatisticsDialogService();
    navigationService = MockNavigationService();
    localGameRepository = MockLocalGameRepository();
    localGameService = MockLocalGameService();
    localRuleSetRepository = MockLocalRuleSetRepository();

    app.registerSingleton<RuleService>(ruleService);
    app.registerSingleton<StatisticsDialogService>(dialogService);
    app.registerSingleton<NavigationService>(navigationService);
    app.registerSingleton<LocalGameRepository>(localGameRepository);
    app.registerSingleton<GameService>(localGameService);
    app.registerSingleton<LocalRuleSetRepository>(localRuleSetRepository);
  });

  tearDownAll(() => app.reset());

  group('Test loading rule set', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'load rule set and emit to state',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [StatisticsState(players: playerList, game: expectedGame)],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should load default rule set with local service',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [StatisticsState(players: playerList, game: expectedGame)],
      tearDown: () {
        app.registerSingleton<RuleService>(ruleService);
      },
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should load own rule set with local service',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(kOwnRuleSet));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.loadRuleSet(),
      expect: () => [
        StatisticsState(
          players: playerList,
          game: expectedGame.copyWith(ruleSet: kOwnRuleSet),
        ),
      ],
      tearDown: () {
        app.registerSingleton<RuleService>(ruleService);
      },
    );
  });

  /**
   * Da die Zustandsänderung, die durch emit ausgelöst wird,
   * im Konstruktor stattfindet, wird sie von blocTest nicht als
   * Zustandsänderung erkannt, die nach der Initialisierung passiert.
   */
  group('Test to load correct game', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'Should load game',
      build: () => StatisticsCubit(players: playerList),
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
      },
      act: (cubit) => cubit.loadGame(game: expectedGame),
      expect: () => [StatisticsState(players: playerList, game: expectedGame)],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'Should create game',
      build: () => StatisticsCubit(players: playerList),
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(kOwnRuleSet));
      },
      act: (cubit) => cubit.loadGame(),
      expect: () => [
        StatisticsState(
          players: playerList,
          game: expectedGame.copyWith(ruleSet: kOwnRuleSet),
        ),
      ],
    );
  });

  group('Test closing round method', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with default rule set and ZERO players',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
      },
      build: () => StatisticsCubit(players: <Player>[]),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: const <Player>[],
          game: Game(
            players: const <Player>[],
            startedAt: gameStartedDate,
            ruleSet: ruleSet,
          ),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with DEFAULT rule set and penalty',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapDefaultRulesPenalty));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(players: playerList, game: expectedGame),
        StatisticsState(
          players: expectedPlayerListWithDefaultRulesAndPenalty,
          game: expectedGame.copyWith(
            players: expectedPlayerListWithDefaultRulesAndPenalty,
          ),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with DEFAULT rule set',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapDefaultRules));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(players: playerList, game: expectedGame),
        StatisticsState(
          players: expectedPlayerListWithDefaultRules,
          game: expectedGame.copyWith(
            players: expectedPlayerListWithDefaultRules,
          ),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with player hitting kamikaze ',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapDefaultRulesKamikaze));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(players: playerList, game: expectedGame),
        StatisticsState(
          game: expectedGame.copyWith(
            players: expectedPlayerListWithDefaultRulesHittingKamikaze,
          ),
          players: expectedPlayerListWithDefaultRulesHittingKamikaze,
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with OWN rule set and penalty',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(kOwnRuleSet));
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapOwnRulesPenalty));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) async {
        // Stellt sicher, dass der Cubit initialisiert wird
        await Future.delayed(const Duration(milliseconds: 50));
        cubit.closeRound();
      },
      expect: () => [
        StatisticsState(
          players: playerList,
          game: expectedGame.copyWith(ruleSet: kOwnRuleSet),
        ),
        StatisticsState(
          players: expectedPlayerListWithOwnRulesAndPenalty,
          game: expectedGame.copyWith(
            players: expectedPlayerListWithOwnRulesAndPenalty,
            ruleSet: kOwnRuleSet,
          ),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should close round with OWN rule set',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(kOwnRuleSet));
        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));
        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapOwnRules));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) async {
        // Stellt sicher, dass der Cubit initialisiert wird
        await Future.delayed(const Duration(milliseconds: 50));
        cubit.closeRound();
      },
      expect: () => [
        StatisticsState(
          players: playerList,
          game: expectedGame.copyWith(ruleSet: kOwnRuleSet),
        ),
        StatisticsState(
          players: expectedPlayerListWithOwnRules,
          game: expectedGame.copyWith(
            players: expectedPlayerListWithOwnRules,
            ruleSet: kOwnRuleSet,
          ),
        ),
      ],
    );
  });

  group('Test precision landing on round close ', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'should reset to 50 points on precision landing',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));
        when(
          dialogService.showRoundCloserDialog(
            players: playerListPrecisionLanding,
          ),
        ).thenAnswer((_) => Future.value(playerListPrecisionLanding[0]));
        when(
          dialogService.showPointDialog(playerListPrecisionLanding),
        ).thenAnswer(
          (_) => Future.value(pointsMapDefaultRulesPrecisionLanding),
        );
      },
      build: () => StatisticsCubit(players: playerListPrecisionLanding),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: playerListPrecisionLanding,
          game: expectedPrecisionLandingGame,
        ),
        StatisticsState(
          players: expectedPlayerListWithDefaultRulesPrecisionLanding,
          game: expectedPrecisionLandingGame.copyWith(
            players: expectedPlayerListWithDefaultRulesPrecisionLanding,
          ),
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.game?.players[1].name, 'Maike');
        expect(cubit.state.game?.players[1].totalPoints, 50);
      },
    );
  });
}
