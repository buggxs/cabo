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

@GenerateNiceMocks(<MockSpec<Object>>[
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

  final List<Player> playerList = <Player>[
    const Player(name: bob),
    const Player(name: leo),
    const Player(name: mia),
  ];

  final RuleSet ruleSet = const RuleSet();

  final String gameStartedDate = DateFormat(
    'dd-MM-yyyy HH:mm',
  ).format(DateTime.now());

  final Game game = Game(
    players: playerList,
    ruleSet: ruleSet,
    startedAt: gameStartedDate,
    seatingOrder: playerList.map((Player player) => player.name).toList(),
  );

  final List<Player> expectedPlayerListFirstRound = <Player>[
    const Player(
      name: bob,
      place: 1,
      rounds: <Round>[
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
      rounds: <Round>[
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
      rounds: <Round>[
        Round(
          round: 1,
          points: 6,
          hasPenaltyPoints: false,
          hasClosedRound: false,
        ),
      ],
    ),
  ];

  final Map<String, int> pointsMapFirstRound = <String, int>{
    bob: 3,
    leo: 4,
    mia: 6,
  };

  final List<Player> expectedPlayerListSecondRound = <Player>[
    const Player(
      name: leo,
      place: 1,
      rounds: <Round>[
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
      rounds: <Round>[
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
      rounds: <Round>[
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

  final Map<String, int> pointsMapSecondRound = <String, int>{
    bob: 7,
    leo: 2,
    mia: 11,
  };

  final List<Player> expectedPlayerListThirdRound = <Player>[
    const Player(
      name: leo,
      place: 1,
      rounds: <Round>[
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
      rounds: <Round>[
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
      rounds: <Round>[
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

  final Map<String, int> pointsMapThirdRound = <String, int>{
    bob: 3,
    leo: 2,
    mia: 3,
  };

  final List<Player> expectedPlayerListFourthRound = <Player>[
    const Player(
      name: leo,
      place: 1,
      rounds: <Round>[
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
      rounds: <Round>[
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
      rounds: <Round>[
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

  final Map<String, int> pointsMapFourthRound = <String, int>{
    leo: 4,
    bob: 7,
    mia: 4,
  };

  final List<Player> expectedPlayerListFivthRound = <Player>[
    const Player(
      name: mia,
      place: 1,
      rounds: <Round>[
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
          isKamikazeRound: true,
          isWonRound: true,
        ),
      ],
    ),
    const Player(
      name: leo,
      place: 2,
      rounds: <Round>[
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
          isKamikazeRound: true,
          isWonRound: false,
        ),
      ],
    ),
    const Player(
      name: bob,
      place: 3,
      rounds: <Round>[
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
          isKamikazeRound: true,
          isWonRound: false,
        ),
      ],
    ),
  ];

  final Map<String, int> pointsMapFivthRound = <String, int>{
    leo: 2,
    bob: 6,
    mia: 50,
  };

  final List<Player> expectedPlayerListSixthRound = <Player>[
    const Player(
      name: mia,
      place: 1,
      rounds: <Round>[
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
          isKamikazeRound: true,
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
      rounds: <Round>[
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
          isKamikazeRound: true,
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
      rounds: <Round>[
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
          isKamikazeRound: true,
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

  final Map<String, int> pointsMapSixthRound = <String, int>{
    leo: 2,
    bob: 2,
    mia: 3,
  };

  final List<Player> expectedPlayerListSeventhRound = <Player>[
    const Player(
      name: mia,
      place: 1,
      rounds: <Round>[
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
          isKamikazeRound: true,
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
      rounds: <Round>[
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
          isKamikazeRound: true,
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
      rounds: <Round>[
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
          isKamikazeRound: true,
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

  final Map<String, int> pointsMapSeventhRound = <String, int>{
    leo: 4,
    bob: 4,
    mia: 8,
  };

  late RuleService ruleService;
  late StatisticsDialogService dialogService;
  late NavigationService navigationService;
  late LocalGameRepository localGameRepository;
  late LocalGameService localGameService;
  late LocalRuleSetRepository localRuleSetRepository;
  late final GetIt app = GetIt.instance;

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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: playerList),
        ).thenAnswer((_) => Future<Player?>.value(playerList[0]));

        when(
          dialogService.showPointDialog(playerList, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapFirstRound),
        );
      },
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListFirstRound[1]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapSecondRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFirstRound,
        game: game.copyWith(players: expectedPlayerListFirstRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListSecondRound[2]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapThirdRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListSecondRound,
        game: game.copyWith(players: expectedPlayerListSecondRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListThirdRound[1]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapFourthRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListThirdRound,
        game: game.copyWith(players: expectedPlayerListThirdRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListFourthRound[2]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapFivthRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFourthRound,
        game: game.copyWith(players: expectedPlayerListFourthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListFivthRound[0]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapSixthRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListFivthRound,
        game: game.copyWith(players: expectedPlayerListFivthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
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
        ).thenAnswer((_) => Future<RuleSet>.value(const RuleSet()));

        when(
          dialogService.showRoundCloserDialog(players: anyNamed('players')),
        ).thenAnswer(
          (_) => Future<Player?>.value(expectedPlayerListSixthRound[2]),
        );

        when(
          dialogService.showPointDialog(any, closer: anyNamed('closer')),
        ).thenAnswer(
          (_) => Future<Map<String, int?>?>.value(pointsMapSeventhRound),
        );
      },
      seed: () => StatisticsState(
        players: expectedPlayerListSixthRound,
        game: game.copyWith(players: expectedPlayerListSixthRound),
      ),
      build: () => StatisticsCubit(players: playerList),
      act: (StatisticsCubit cubit) => cubit.closeRound(),
      expect: () => <StatisticsState>[
        StatisticsState(
          players: expectedPlayerListSeventhRound,
          game: game.copyWith(players: expectedPlayerListSeventhRound),
        ),
      ],
    );
  });
}
