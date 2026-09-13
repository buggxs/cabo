import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Round> buildRounds(int count) {
    return <Round>[
      for (int i = 1; i <= count; i++)
        Round(
          round: i,
          points: i,
          hasClosedRound: false,
          hasPenaltyPoints: false,
          isWonRound: false,
        ),
    ];
  }

  Game buildGame({
    required List<String> playerNames,
    required List<String> seatingOrder,
    int playedRounds = 0,
  }) {
    return Game(
      players: playerNames
          .map(
            (String name) =>
                Player(name: name, rounds: buildRounds(playedRounds)),
          )
          .toList(),
      ruleSet: const RuleSet(),
      seatingOrder: seatingOrder,
    );
  }

  group('currentDealerName', () {
    const List<String> seatingOrder = <String>['Kevin', 'Maike', 'Mia'];

    test('starts with the first player of the seating order', () {
      final Game game = buildGame(
        playerNames: seatingOrder,
        seatingOrder: seatingOrder,
      );

      expect(game.currentDealerName, 'Kevin');
    });

    test('moves to the next player after every round', () {
      for (int playedRounds = 0; playedRounds < 7; playedRounds++) {
        final Game game = buildGame(
          playerNames: seatingOrder,
          seatingOrder: seatingOrder,
          playedRounds: playedRounds,
        );

        expect(game.currentDealerName, seatingOrder[playedRounds % 3]);
      }
    });

    test('ignores a player order changed by placement', () {
      final Game game = buildGame(
        playerNames: <String>['Mia', 'Kevin', 'Maike'],
        seatingOrder: seatingOrder,
        playedRounds: 1,
      );

      expect(game.currentDealerName, 'Maike');
    });

    test('falls back to the player order without a seating order', () {
      final Game game = buildGame(
        playerNames: <String>['Mia', 'Kevin', 'Maike'],
        seatingOrder: const <String>[],
        playedRounds: 1,
      );

      expect(game.currentDealerName, 'Kevin');
    });

    test('returns null without players', () {
      const Game game = Game(players: <Player>[], ruleSet: RuleSet());

      expect(game.currentDealerName, isNull);
    });
  });
}
