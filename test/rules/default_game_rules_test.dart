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

import 'default_game_rules_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalRuleService>(),
  MockSpec<StatisticsDialogService>(),
  MockSpec<NavigationService>(),
  MockSpec<LocalGameRepository>(),
  MockSpec<LocalRuleSetRepository>(),
  MockSpec<LocalGameService>(),
])
void main() {
  const String bob = 'Bob';
  const String leo = 'Leo';
  const String mia = 'Mia';

  List<Player> playerList = [
    const Player(name: bob),
    const Player(name: leo),
    const Player(name: mia),
  ];

  RuleSet ruleSet = const RuleSet();

  String gameStartedDate = DateFormat(
    'dd-MM-yyyy HH:mm',
  ).format(DateTime.now());

  Game game = Game(
    players: playerList,
    ruleSet: ruleSet,
    startedAt: gameStartedDate,
  );

  List<Player> expectedPlayerListFirstRound = [
    const Player(
      name: bob,
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
      name: leo,
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
      name: mia,
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

  Map<String, int> pointsMapFirstRound = {bob: 3, leo: 4, mia: 6};

  List<Player> expectedPlayerListSecondRound = [
    const Player(
      name: leo,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: mia,
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapSecondRound = {bob: 7, leo: 2, mia: 11};

  List<Player> expectedPlayerListThirdRound = [
    const Player(
      name: leo,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
          hasClosedRound: false,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: mia,
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapThirdRound = {bob: 3, leo: 2, mia: 3};

  List<Player> expectedPlayerListFourthRound = [
    const Player(
      name: leo,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 12,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: mia,
      place: 3,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapFourthRound = {leo: 4, bob: 7, mia: 4};

  List<Player> expectedPlayerListFivthRound = [
    const Player(
      name: mia,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: leo,
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 12,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapFivthRound = {leo: 2, bob: 6, mia: 50};

  List<Player> expectedPlayerListSixthRound = [
    const Player(
      name: mia,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 6,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: leo,
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 6,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 12,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 6,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapSixthRound = {leo: 2, bob: 2, mia: 3};

  List<Player> expectedPlayerListSeventhRound = [
    const Player(
      name: mia,
      place: 1,
      rounds: [
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 2,
          points: 11,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
        Round(
          round: 6,
          points: 8,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 7,
          points: 8,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: leo,
      place: 2,
      rounds: [
        Round(
          round: 1,
          points: 4,
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
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 4,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 6,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 7,
          points: 4,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: bob,
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
          points: 7,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 3,
          points: 3,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 4,
          points: 12,
          hasPenaltyPoints: true,
          hasClosedRound: true,
          isWonRound: false,
        ),
        Round(
          round: 5,
          points: 50,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: false,
        ),
        Round(
          round: 6,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: false,
          isWonRound: true,
        ),
        Round(
          round: 7,
          points: 0,
          hasPenaltyPoints: false,
          hasClosedRound: true,
          isWonRound: true,
        ),
      ],
    ),
  ];

  Map<String, int> pointsMapSeventhRound = {leo: 4, bob: 4, mia: 8};

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

  group('Test original game logic', () {
    blocTest<StatisticsCubit, StatisticsState>(
      'should close first round with correct points',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future.value(playerList[0]));

        when(
          dialogService.showPointDialog(playerList),
        ).thenAnswer((_) => Future.value(pointsMapFirstRound));
      },
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(players: playerList, game: game),
        StatisticsState(
          players: expectedPlayerListFirstRound,
          game: game.copyWith(players: expectedPlayerListFirstRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing second round with place swap',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListFirstRound[1]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapSecondRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFirstRound,
        game: game.copyWith(players: expectedPlayerListFirstRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListSecondRound,
          game: game.copyWith(players: expectedPlayerListSecondRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing third round with penalty points',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListSecondRound[2]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapThirdRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListSecondRound,
        game: game.copyWith(players: expectedPlayerListSecondRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListThirdRound,
          game: game.copyWith(players: expectedPlayerListThirdRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing fourth round with penalty points and '
      'tie between the two players who won',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListThirdRound[1]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapFourthRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListThirdRound,
        game: game.copyWith(players: expectedPlayerListThirdRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListFourthRound,
          game: game.copyWith(players: expectedPlayerListFourthRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing fivth round with kamikatze and place swap',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListFourthRound[2]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapFivthRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFourthRound,
        game: game.copyWith(players: expectedPlayerListFourthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListFivthRound,
          game: game.copyWith(players: expectedPlayerListFivthRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing sixth round with closing player lost and the '
      'other two lowest players are on a tie',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListFivthRound[0]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapSixthRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFivthRound,
        game: game.copyWith(players: expectedPlayerListFivthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListSixthRound,
          game: game.copyWith(players: expectedPlayerListSixthRound),
        ),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'should simulate closing seventh round with closing player winning and '
      'another player is on tie with round closer',
      setUp: () {
        when(
          ruleService.loadRuleSet(),
        ).thenAnswer((_) => Future.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer((_) => Future.value(expectedPlayerListSixthRound[2]));

        when(
          dialogService.showPointDialog(any),
        ).thenAnswer((_) => Future.value(pointsMapSeventhRound));
      },
      seed: () => StatisticsState(
        players: expectedPlayerListSixthRound,
        game: game.copyWith(players: expectedPlayerListSixthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (cubit) => cubit.closeRound(),
      expect: () => [
        StatisticsState(
          players: expectedPlayerListSeventhRound,
          game: game.copyWith(players: expectedPlayerListSeventhRound),
        ),
      ],
    );
  });
}
