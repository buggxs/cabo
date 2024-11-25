import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';
import 'package:cabo/misc/utils/gaming_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculatePlayedRounds', () {
    test('should return 0 when the games list is empty', () {
      final games = <Game>[];
      expect(calculatePlayedRounds(games), 0);
    });

    test('should return the correct number of total rounds', () {
      const games = <Game>[
        Game(
          id: 1,
          startedAt: '2023-01-01',
          finishedAt: '2023-01-02',
          players: [
            Player(
                id: 1,
                name: 'Alice',
                rounds: [Round(round: 1), Round(round: 1)]),
            Player(id: 2, name: 'Bob', rounds: [Round(round: 1)]),
          ],
          ruleSetId: 1,
          ruleSet: RuleSet(),
        ),
        Game(
          id: 2,
          startedAt: '2023-01-03',
          finishedAt: '2023-01-04',
          players: [
            Player(
                id: 3,
                name: 'Charlie',
                rounds: [Round(round: 1), Round(round: 1), Round(round: 1)]),
          ],
          ruleSetId: 2,
          ruleSet: RuleSet(),
        ),
      ];

      expect(calculatePlayedRounds(games), 6); // Alice: 2, Bob: 1, Charlie: 3
    });

    test('should handle games with no players', () {
      const games = <Game>[
        Game(
          id: 1,
          startedAt: '2023-01-01',
          finishedAt: '2023-01-02',
          players: [],
          ruleSetId: 1,
          ruleSet: RuleSet(),
        ),
      ];

      expect(calculatePlayedRounds(games), 0);
    });

    test('should handle players with no rounds', () {
      const games = <Game>[
        Game(
          id: 1,
          startedAt: '2023-01-01',
          finishedAt: '2023-01-02',
          players: [
            Player(id: 1, name: 'Alice', rounds: []),
            Player(id: 2, name: 'Bob', rounds: []),
          ],
          ruleSetId: 1,
          ruleSet: RuleSet(),
        ),
      ];

      expect(calculatePlayedRounds(games), 0);
    });

    test('should handle multiple games and mixed player data', () {
      const games = <Game>[
        Game(
          id: 1,
          startedAt: '2023-01-01',
          finishedAt: '2023-01-02',
          players: [
            Player(
                id: 1,
                name: 'Alice',
                rounds: [Round(round: 1), Round(round: 1)]),
          ],
          ruleSetId: 1,
          ruleSet: RuleSet(),
        ),
        Game(
          id: 2,
          startedAt: '2023-01-03',
          finishedAt: '2023-01-04',
          players: [
            Player(id: 2, name: 'Bob', rounds: []),
            Player(id: 3, name: 'Charlie', rounds: [Round(round: 1)]),
          ],
          ruleSetId: 2,
          ruleSet: RuleSet(),
        ),
      ];

      expect(calculatePlayedRounds(games), 3); // Alice: 2, Bob: 0, Charlie: 1
    });
  });
}
