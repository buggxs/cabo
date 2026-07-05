import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Spielkarte im neuen Material-3-Design: heller Container mit Streak-Badge,
/// Spieldauer und je Spieler einer Sub-Karte (Verlierer rot hervorgehoben).
class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game});

  final Game game;

  /// Standard-Schatten der neuen Karten (rgba(61,58,53,0.08)).
  static const List<BoxShadow> _cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x143D3A35), blurRadius: 12, offset: Offset(0, 4)),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Player> sortedPlayers = List<Player>.from(game.players)
      ..sort((Player a, Player b) => (a.place ?? 99).compareTo(b.place ?? 99));

    final int lastPlace = sortedPlayers
        .map((Player p) => p.place ?? 0)
        .fold(0, (int a, int b) => a > b ? a : b);

    final List<GameStreakType> streaks = game.getGameStreakTypes();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context, streaks),
          const SizedBox(height: 12),
          for (final Player player in sortedPlayers) ...<Widget>[
            _buildPlayerRow(
              context,
              player,
              isLoser: (player.place ?? 0) == lastPlace && lastPlace > 1,
            ),
            if (player != sortedPlayers.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<GameStreakType> streaks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (streaks.isNotEmpty)
          _buildStreakBadge(context, streaks)
        else
          const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.schedule,
              size: 14,
              color: CaboTheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              _compactDuration(),
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBadge(BuildContext context, List<GameStreakType> streaks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: CaboTheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final GameStreakType type in streaks)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                _streakIcon(type),
                size: 14,
                color: CaboTheme.m3Tertiary,
              ),
            ),
          Text(
            context.l10n.historyScreenStreaksActive,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.m3Tertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _streakIcon(GameStreakType type) {
    switch (type) {
      case GameStreakType.fiveRoundsWon:
      case GameStreakType.sevenRoundsWon:
      case GameStreakType.tenRoundsWon:
        return Icons.local_fire_department_rounded;
      case GameStreakType.oneHourGame:
      case GameStreakType.oneAndHalfHoursGame:
      case GameStreakType.twoHoursGame:
        return Icons.timer_outlined;
    }
  }

  Widget _buildPlayerRow(
    BuildContext context,
    Player player, {
    required bool isLoser,
  }) {
    final int place = player.place ?? 0;
    final bool isWinner = place == 1;

    final Color background = isLoser
        ? CaboTheme.errorContainer
        : CaboTheme.surfaceContainerLowest;
    final Color nameColor = isLoser
        ? CaboTheme.onErrorContainer
        : CaboTheme.onSurface;
    final Color scoreColor = isLoser
        ? CaboTheme.m3Error
        : (isWinner ? CaboTheme.m3Primary : CaboTheme.onSurface);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      ),
      child: Row(
        children: <Widget>[
          _buildPlaceBadge(place, isLoser: isLoser),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: nameColor,
                fontWeight: isWinner || isLoser
                    ? FontWeight.bold
                    : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${player.totalPoints}',
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: scoreColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceBadge(int place, {required bool isLoser}) {
    if (isLoser) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: CaboTheme.m3Error.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: CaboTheme.m3Error,
          size: 18,
        ),
      );
    }

    if (place == 1) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: CaboTheme.firstPlaceColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.emoji_events,
          color: CaboTheme.onPrimary,
          size: 18,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: CaboTheme.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          place > 0 ? '$place' : '-',
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Kompakte Spieldauer im Format `HH:MMh` aus `startedAt`/`finishedAt`.
  String _compactDuration() {
    final String? startedAt = game.startedAt;
    final String? finishedAt = game.finishedAt;
    if (startedAt == null || finishedAt == null) {
      return '–';
    }

    final DateTime? start = DateFormat().parseCaboDateString(startedAt);
    final DateTime? end = DateFormat().parseCaboDateString(finishedAt);
    if (start == null || end == null || end.isBefore(start)) {
      return '–';
    }

    final Duration duration = end.difference(start);
    final String hours = duration.inHours.toString().padLeft(2, '0');
    final String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:${minutes}h';
  }
}
