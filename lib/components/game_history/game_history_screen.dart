import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/game_history/cubit/game_history_cubit.dart';
import 'package:cabo/components/game_history/widget/animated_total_points_banner.dart';
import 'package:cabo/components/game_history/widget/game_card.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:cabo/misc/utils/gaming_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({super.key});

  static const String route = 'game_history_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameHistoryCubit()..loadGames(),
      child: const GameHistoryScreenContent(),
    );
  }
}

class GameHistoryScreenContent extends StatelessWidget {
  const GameHistoryScreenContent({super.key});

  static const List<BoxShadow> _cardShadow = <BoxShadow>[
    BoxShadow(color: Color(0x143D3A35), blurRadius: 12, offset: Offset(0, 4)),
  ];

  @override
  Widget build(BuildContext context) {
    final GameHistoryCubit cubit = context.watch<GameHistoryCubit>();
    final List<Game> games = cubit.state.games;

    final int playedRounds = calculatePlayedRounds(games);
    final int gameAmount = games.length;
    final (int days, int hours) = calculateTotalPlayTimeParts(games);
    final int totalCollectedPoints = calculateTotalPoints(games);

    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 72,
        backgroundColor: CaboTheme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.l10n.historyScreenTitle,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
            ),
            Text(
              context.l10n.historyScreenSubtitle,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: <Widget>[
                _buildSummaryRow(
                  context,
                  gameAmount: gameAmount,
                  days: days,
                  hours: hours,
                  playedRounds: playedRounds,
                ),
                const SizedBox(height: 20),
                AnimatedTotalPointsBanner(
                  totalCollectedPoints: totalCollectedPoints,
                ),
                const SizedBox(height: 24),
                ..._buildGroupedGames(context, games),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required int gameAmount,
    required int days,
    required int hours,
    required int playedRounds,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _buildStatCard(
              icon: Icons.sports_esports,
              value: '$gameAmount',
              label: context.l10n.historyScreenGamesCardTitle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.alarm,
              value: _formatPlayTime(context, days, hours),
              label: context.l10n.historyScreenGameTimeCardTitle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.military_tech,
              value: '$playedRounds',
              label: context.l10n.historyScreenPlayedRoundsCardTitle,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPlayTime(BuildContext context, int days, int hours) {
    final String hoursPart = '$hours ${context.l10n.historyScreenHoursShort}';
    if (days > 0) {
      return '$days ${context.l10n.historyScreenDaysShort}\n$hoursPart';
    }
    return hoursPart;
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: CaboTheme.m3Primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedGames(BuildContext context, List<Game> games) {
    final Map<String, List<Game>> grouped = <String, List<Game>>{};
    for (final Game game in games) {
      final DateTime? date = game.startedAt == null
          ? null
          : DateFormat().parseCaboDateString(game.startedAt!);
      final String key = date == null
          ? ''
          : DateFormat('dd. MMM yyyy').format(date);
      grouped.putIfAbsent(key, () => <Game>[]).add(game);
    }

    final List<Widget> widgets = <Widget>[];
    grouped.forEach((String dateLabel, List<Game> gamesOfDay) {
      if (dateLabel.isNotEmpty) {
        widgets.add(_buildDateHeader(dateLabel));
        widgets.add(const SizedBox(height: 12));
      }
      for (final Game game in gamesOfDay) {
        widgets.add(GameCard(game: game));
        widgets.add(const SizedBox(height: 16));
      }
      widgets.add(const SizedBox(height: 8));
    });

    return widgets;
  }

  Widget _buildDateHeader(String dateLabel) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: CaboTheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          dateLabel,
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
