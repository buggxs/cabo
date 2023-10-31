import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';

List<Player> MOCK_PLAYER_LIST = <Player>[
  Player(name: 'Andre', rounds: MOCK_ROUND_LIST),
  Player(name: 'Michi', rounds: MOCK_ROUND_LIST),
  Player(name: 'Pascal', rounds: MOCK_ROUND_LIST_PENALTY),
];

const List<Round> MOCK_ROUND_LIST = <Round>[
  Round(round: 1, points: 23),
];

const List<Round> MOCK_ROUND_LIST_PENALTY = <Round>[
  Round(round: 1, points: 23, hasPenaltyPoints: true),
];
