import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Final screen shown after a game ends. Celebrates the winner (hero card and
/// confetti) and shows the complete ranking. Replaces the old `WinnerDialog`.
class EndGameScreen extends StatefulWidget {
  const EndGameScreen({super.key, required this.game});

  static const String route = 'end_game_screen';

  final Game game;

  @override
  State<EndGameScreen> createState() => _EndGameScreenState();
}

class _EndGameScreenState extends State<EndGameScreen> {
  late final ConfettiController _confettiController;

  // rgba(61, 58, 53, 0.08)
  static const List<BoxShadow> _cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x143D3A35), blurRadius: 12, offset: Offset(0, 4)),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  List<Player> get _rankedPlayers {
    final List<Player> players = List<Player>.from(widget.game.players)
      ..sort((Player a, Player b) {
        final int placeA = a.place ?? 1 << 30;
        final int placeB = b.place ?? 1 << 30;
        return placeA.compareTo(placeB);
      });
    return players;
  }

  void _returnToMenu() {
    unawaited(app<RatingService>().trackGameCompletion());
    app<NavigationService>().pushNamedAndRemoveAll(MainMenuScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final List<Player> ranked = _rankedPlayers;
    final Player? winner = ranked.firstOrNull;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        _returnToMenu();
      },
      child: Scaffold(
        backgroundColor: CaboTheme.scaffoldBackground,
        body: Stack(
          children: <Widget>[
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 576),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    children: _buildContent(context, ranked, winner),
                  ),
                ),
              ),
            ),
            _buildConfetti(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent(
    BuildContext context,
    List<Player> ranked,
    Player? winner,
  ) {
    return <Widget>[
      Text(
        context.l10n.winnerDialogTitle,
        textAlign: TextAlign.center,
        style: CaboTheme.displayLargeStyle.copyWith(color: CaboTheme.m3Primary),
      ),
      const SizedBox(height: 24),
      if (winner != null) _buildWinnerHero(context, winner),
      const SizedBox(height: 24),
      _buildSummaryRow(context, ranked),
      const SizedBox(height: 32),
      _buildSectionLabel(context.l10n.endGameRankingTitle),
      const SizedBox(height: 8),
      _buildRankingCard(context, ranked),
      const SizedBox(height: 32),
      _buildSectionLabel(context.l10n.endGameDetailedTitle),
      const SizedBox(height: 8),
      for (int i = 0; i < ranked.length; i++) ...<Widget>[
        _buildDetailedStatsCard(context, ranked[i], isWinner: i == 0),
        if (i != ranked.length - 1) const SizedBox(height: 12),
      ],
      if (ranked.firstOrNull?.rounds.isNotEmpty ?? false) ...<Widget>[
        const SizedBox(height: 32),
        _buildHighlightsSection(context, ranked),
      ],
      const SizedBox(height: 24),
      CaboPrimaryButton(
        label: context.l10n.endGameBackToMenu,
        onPressed: _returnToMenu,
      ),
    ];
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.05,
        shouldLoop: false,
        colors: <Color>[
          CaboTheme.primaryContainer,
          CaboTheme.m3Primary,
          CaboTheme.m3Secondary,
          CaboTheme.firstPlaceColor,
          CaboTheme.primaryFixedDim,
        ],
      ),
    );
  }

  Widget _buildWinnerHero(BuildContext context, Player winner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(
          color: CaboTheme.primaryContainer.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: CaboTheme.primaryFixedDim.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Image(
                image: AssetImage('assets/icon/winner_trophy.png'),
                width: 72,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AutoSizeText(
            '${winner.name} ${context.l10n.hasWonText}',
            maxLines: 2,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.l10n.withPointsText} ${winner.totalPoints} ${context.l10n.pointsText}',
            textAlign: TextAlign.center,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.m3Primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: CaboTheme.labelSmallStyle.copyWith(
        color: CaboTheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, List<Player> ranked) {
    final int rounds = ranked.firstOrNull?.rounds.length ?? 0;
    final (String, String) duration = _formatDuration(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.schedule,
            label: context.l10n.endGameDurationLabel,
            value: duration.$1,
            unit: duration.$2,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.style,
            label: context.l10n.endGameRoundsLabel,
            value: '$rounds',
            unit: context.l10n.endGameRoundsUnit,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: CaboTheme.m3Primary, size: 22),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: value,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' $unit',
                  style: CaboTheme.bodyMediumStyle.copyWith(
                    color: CaboTheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns (value, unit) of the game duration, or '–' for missing or
  // invalid timestamps.
  (String, String) _formatDuration(BuildContext context) {
    final String? startedAt = widget.game.startedAt;
    final String? finishedAt = widget.game.finishedAt;
    if (startedAt == null ||
        startedAt.isEmpty ||
        finishedAt == null ||
        finishedAt.isEmpty) {
      return ('–', context.l10n.endGameDurationUnitMinutes);
    }

    try {
      final DateFormat format = DateFormat('dd-MM-yyyy HH:mm');
      final Duration diff = format
          .parse(finishedAt)
          .difference(format.parse(startedAt));
      final int totalMinutes = diff.inMinutes;
      if (totalMinutes >= 60) {
        final int hours = totalMinutes ~/ 60;
        final int minutes = totalMinutes % 60;
        return (
          '$hours:${minutes.toString().padLeft(2, '0')}',
          context.l10n.endGameDurationUnitHours,
        );
      }
      return ('$totalMinutes', context.l10n.endGameDurationUnitMinutes);
    } on FormatException {
      return ('–', context.l10n.endGameDurationUnitMinutes);
    }
  }

  // Per player: total points and three key figures (Cabo zero, penalty
  // points, average per round). The winner gets a coloured header.
  Widget _buildDetailedStatsCard(
    BuildContext context,
    Player player, {
    required bool isWinner,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          _buildDetailedStatsHeader(context, player, isWinner: isWinner),
          _buildDetailedStatsRow(context, player),
        ],
      ),
    );
  }

  Widget _buildDetailedStatsHeader(
    BuildContext context,
    Player player, {
    required bool isWinner,
  }) {
    final Color headerBg = isWinner
        ? CaboTheme.primaryContainer
        : CaboTheme.surfaceVariant;
    final Color headerFg = isWinner
        ? CaboTheme.onPrimaryContainer
        : CaboTheme.onSurfaceVariant;

    return Container(
      color: headerBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CaboTheme.headlineMediumStyle.copyWith(color: headerFg),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                context.l10n.endGameStatTotal.toUpperCase(),
                style: CaboTheme.labelSmallStyle.copyWith(
                  color: headerFg.withValues(alpha: 0.8),
                ),
              ),
              Text(
                '${player.totalPoints} ${context.l10n.endGamePointsShort}',
                style: CaboTheme.headlineMediumStyle.copyWith(
                  color: headerFg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatsRow(BuildContext context, Player player) {
    final int caboZero = player.rounds
        .where((Round round) => round.points == 0)
        .length;
    final int penaltyPoints =
        player.rounds.where((Round round) => round.hasPenaltyPoints).length * 5;
    final int roundCount = player.rounds.length;
    final String average = roundCount == 0
        ? '0'
        : (player.totalPoints / roundCount).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildStatCell(
              value: '$caboZero',
              label: context.l10n.endGameStatCaboZero,
              valueColor: caboZero > 0
                  ? CaboTheme.m3Secondary
                  : CaboTheme.onSurface,
            ),
          ),
          Expanded(
            child: _buildStatCell(
              value: penaltyPoints > 0 ? '+$penaltyPoints' : '0',
              label: context.l10n.endGameStatPenalty,
              valueColor: penaltyPoints > 0
                  ? CaboTheme.m3Error
                  : CaboTheme.onSurface,
            ),
          ),
          Expanded(
            child: _buildStatCell(
              value: average,
              label: context.l10n.endGameStatAverage,
              valueColor: CaboTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCell({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: CaboTheme.headlineMediumStyle.copyWith(color: valueColor),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: CaboTheme.labelSmallStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Score-pad styled card with the best round (lowest total) and, if any, the
  // longest win streak.
  Widget _buildHighlightsSection(BuildContext context, List<Player> ranked) {
    final List<Widget> rows = <Widget>[];

    final Widget? bestRound = _buildBestRoundHighlight(context, ranked);
    if (bestRound != null) {
      rows.add(bestRound);
    }

    final Widget? longestStreak = _buildLongestStreakHighlight(context, ranked);
    if (longestStreak != null) {
      rows.add(longestStreak);
    }

    rows.addAll(_buildGameStreakHighlights(context));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CaboTheme.background,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: CaboTheme.outlineVariant),
              ),
            ),
            width: double.infinity,
            child: Text(
              context.l10n.endGameHighlightsTitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: CaboTheme.labelLargeStyle.copyWith(
                color: CaboTheme.m3Primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < rows.length; i++) ...<Widget>[
            rows[i],
            if (i != rows.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightRow({
    required IconData icon,
    required Color iconBg,
    required Color iconFg,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: <Widget>[
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconFg, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: CaboTheme.bodyMediumStyle.copyWith(
                  color: CaboTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: CaboTheme.labelSmallStyle.copyWith(
                  color: CaboTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // The round with the lowest total points across all players.
  Widget? _buildBestRoundHighlight(BuildContext context, List<Player> ranked) {
    final int roundCount = ranked
        .map((Player p) => p.rounds.length)
        .fold(0, (int a, int b) => a > b ? a : b);
    if (roundCount == 0) {
      return null;
    }

    int? bestRoundIndex;
    int bestTotal = 0;
    for (int i = 0; i < roundCount; i++) {
      int total = 0;
      for (final Player player in ranked) {
        if (i < player.rounds.length) {
          total += player.rounds[i].points;
        }
      }
      if (bestRoundIndex == null || total < bestTotal) {
        bestRoundIndex = i;
        bestTotal = total;
      }
    }

    return _buildHighlightRow(
      icon: Icons.military_tech,
      iconBg: CaboTheme.secondaryContainer,
      iconFg: CaboTheme.onSecondaryContainer,
      title: context.l10n.endGameHighlightBestRound,
      subtitle:
          '$bestTotal ${context.l10n.endGamePointsShort} '
          '${context.l10n.endGameHighlightTotalSuffix} — '
          '${context.l10n.endGameRoundLabel} ${bestRoundIndex! + 1}',
    );
  }

  // Only shown for a streak of at least two rounds in a row.
  Widget? _buildLongestStreakHighlight(
    BuildContext context,
    List<Player> ranked,
  ) {
    Player? best;
    int bestStreak = 0;
    for (final Player player in ranked) {
      final int streak = player.longestRoundWinStreak;
      if (streak > bestStreak) {
        bestStreak = streak;
        best = player;
      }
    }

    if (best == null || bestStreak < 2) {
      return null;
    }

    return _buildHighlightRow(
      icon: Icons.local_fire_department_rounded,
      iconBg: CaboTheme.tertiaryFixed,
      iconFg: CaboTheme.m3Tertiary,
      title: context.l10n.endGameHighlightLongestStreak,
      subtitle:
          '${best.name} — '
          '${context.l10n.endGameHighlightStreakRounds(bestStreak)}',
    );
  }

  // Win streak milestones (5/7/10) and game duration milestones (1/1.5/2 h).
  List<Widget> _buildGameStreakHighlights(BuildContext context) {
    return widget.game
        .getGameStreakTypes()
        .map((GameStreakType type) => _buildGameStreakHighlight(context, type))
        .toList();
  }

  Widget _buildGameStreakHighlight(BuildContext context, GameStreakType type) {
    final String subtitle = switch (type) {
      GameStreakType.fiveRoundsWon => context.l10n.streakFiveRoundsWon,
      GameStreakType.sevenRoundsWon => context.l10n.streakSevenRoundsWon,
      GameStreakType.tenRoundsWon => context.l10n.streakTenRoundsWon,
      GameStreakType.oneHourGame => context.l10n.streakOneHourGame,
      GameStreakType.oneAndHalfHoursGame =>
        context.l10n.streakOneAndHalfHourGame,
      GameStreakType.twoHoursGame => context.l10n.streakTwoHourGame,
    };

    if (_isWinStreak(type)) {
      return _buildHighlightRow(
        icon: Icons.local_fire_department_rounded,
        iconBg: CaboTheme.primaryFixedDim.withValues(alpha: 0.3),
        iconFg: CaboTheme.m3Primary,
        title: context.l10n.endGameStreakWinTitle,
        subtitle: subtitle,
      );
    }

    return _buildHighlightRow(
      icon: Icons.timer_outlined,
      iconBg: CaboTheme.surfaceContainerHighest,
      iconFg: CaboTheme.onSurfaceVariant,
      title: context.l10n.endGameStreakDurationTitle,
      subtitle: subtitle,
    );
  }

  bool _isWinStreak(GameStreakType type) {
    return type == GameStreakType.fiveRoundsWon ||
        type == GameStreakType.sevenRoundsWon ||
        type == GameStreakType.tenRoundsWon;
  }

  Widget _buildRankingCard(BuildContext context, List<Player> ranked) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < ranked.length; i++)
            _buildRankRow(context, ranked[i], isLast: i == ranked.length - 1),
        ],
      ),
    );
  }

  Widget _buildRankRow(
    BuildContext context,
    Player player, {
    required bool isLast,
  }) {
    final int place = player.place ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: CaboTheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
      ),
      child: Row(
        children: <Widget>[
          _buildPlaceBadge(place),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              player.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: CaboTheme.onSurface,
                fontWeight: place == 1 ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${player.totalPoints} ${context.l10n.pointsText}',
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceBadge(int place) {
    final Color? medalColor = switch (place) {
      1 => CaboTheme.firstPlaceColor,
      2 => CaboTheme.secondPlaceColor,
      3 => CaboTheme.thirdPlaceColor,
      _ => null,
    };

    if (medalColor != null) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: medalColor.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: medalColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            '$place',
            style: CaboTheme.labelLargeStyle.copyWith(color: medalColor),
          ),
        ),
      );
    }

    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '$place',
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
