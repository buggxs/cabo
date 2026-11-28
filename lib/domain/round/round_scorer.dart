import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/domain/rule_set/data/rule_set.dart';

/// Applies the scoring rules of a [RuleSet] to one closed round: penalty
/// points for a failed Cabo, round winners, kamikaze and precision landing.
class RoundScorer {
  RoundScorer({
    required this.ruleSet,
    required this.playerPoints,
    required this.closingPlayerName,
  });

  final RuleSet ruleSet;
  final Map<String, int?> playerPoints;
  final String closingPlayerName;

  late final String? _kamikazePlayerName = _findKamikazePlayer();
  late final bool _hasClosingPlayerLost = _isClosingPlayerLoser();

  // Replaces the round at [index] or appends a new one when [index] is null.
  Player applyRound(Player player, {int? index}) {
    final List<Round> rounds = List<Round>.of(player.rounds);
    if (index != null && index < rounds.length) {
      rounds.removeAt(index);
    }

    final _PlayerRound playerRound = _PlayerRound(
      playerName: player.name,
      roundNumber: rounds.length + 1,
      pointsBeforeRound: player.copyWith(rounds: rounds).totalPoints,
    );

    return player.copyWith(
      rounds: <Round>[...rounds, _buildRound(playerRound)],
    );
  }

  Round _buildRound(_PlayerRound playerRound) {
    if (_kamikazePlayerName != null) {
      return _buildKamikazeRound(playerRound);
    }

    final bool hasPenaltyPoints =
        _hasClosedRound(playerRound) && _hasClosingPlayerLost;
    final bool isWonRound = _hasWonRound(playerRound.playerName);

    int points = playerPoints[playerRound.playerName] ?? 0;
    if (hasPenaltyPoints) {
      points += kFailedCaboPenaltyPoints;
    }
    if (ruleSet.shouldRoundWinnerGetZeroPoints && isWonRound) {
      points = 0;
    }

    return _createRound(
      playerRound,
      points: points,
      isWonRound: isWonRound,
      hasPenaltyPoints: hasPenaltyPoints,
    );
  }

  // A kamikaze replaces the whole round result: the kamikaze player wins the
  // round with zero points, everyone else takes the configured penalty.
  Round _buildKamikazeRound(_PlayerRound playerRound) {
    final bool isKamikazePlayer = _kamikazePlayerName == playerRound.playerName;

    return _createRound(
      playerRound,
      points: isKamikazePlayer ? 0 : ruleSet.kamikazePoints,
      isWonRound: isKamikazePlayer,
      isKamikazeRound: true,
    );
  }

  Round _createRound(
    _PlayerRound playerRound, {
    required int points,
    required bool isWonRound,
    bool hasPenaltyPoints = false,
    bool isKamikazeRound = false,
  }) {
    final int deduction = _precisionLandingDeduction(
      playerRound.pointsBeforeRound + points,
    );

    return Round(
      round: playerRound.roundNumber,
      points: points,
      hasClosedRound: _hasClosedRound(playerRound),
      hasPenaltyPoints: hasPenaltyPoints,
      hasPrecisionLanding: deduction > 0,
      precisionLandingDeduction: deduction > 0 ? deduction : null,
      isKamikazeRound: isKamikazeRound,
      isWonRound: isWonRound,
    );
  }

  bool _hasClosedRound(_PlayerRound playerRound) =>
      playerRound.playerName == closingPlayerName;

  // Landing exactly on the total game points halves the player's score
  // instead of ending the game.
  int _precisionLandingDeduction(int totalPointsAfterRound) {
    if (!ruleSet.hasPrecisionLanding ||
        totalPointsAfterRound != ruleSet.totalGamePoints) {
      return 0;
    }
    return ruleSet.totalGamePoints ~/ 2;
  }

  // The lowest hand wins the round; on a tie the player who called Cabo wins.
  bool _hasWonRound(String playerName) {
    if ((playerPoints[playerName] ?? 0) != _getLowestPoints()) {
      return false;
    }

    if (!_hasClosingPlayerLost) {
      return playerName == closingPlayerName;
    }

    return true;
  }

  String? _findKamikazePlayer() {
    if (!ruleSet.hasKamikazeRule) {
      return null;
    }

    return playerPoints.entries
        .where(
          (MapEntry<String, int?> entry) =>
              entry.value == ruleSet.kamikazePoints,
        )
        .firstOrNull
        ?.key;
  }

  int _getLowestPoints() {
    MapEntry<String, int?>? lowest;
    for (final MapEntry<String, int?> element in playerPoints.entries) {
      lowest ??= element;
      if ((lowest.value ?? 0) >= (element.value ?? 0)) {
        lowest = element;
      }
    }
    return lowest?.value ?? 0;
  }

  int _getPointsOfClosingPlayer() {
    return playerPoints.entries
            .where(
              (MapEntry<String, int?> entry) => entry.key == closingPlayerName,
            )
            .firstOrNull
            ?.value ??
        0;
  }

  bool _isClosingPlayerLoser() {
    final int pointsOfClosingPlayer = _getPointsOfClosingPlayer();
    return playerPoints.entries.any(
      (MapEntry<String, int?> element) =>
          element.key != closingPlayerName &&
          (element.value ?? 0) < pointsOfClosingPlayer,
    );
  }
}

class _PlayerRound {
  const _PlayerRound({
    required this.playerName,
    required this.roundNumber,
    required this.pointsBeforeRound,
  });

  final String playerName;
  final int roundNumber;
  final int pointsBeforeRound;
}
