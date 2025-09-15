import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/game_history/cubit/game_history_cubit.dart';
import 'package:cabo/components/game_history/widget/animated_total_points_banner.dart';
import 'package:cabo/components/game_history/widget/game_card.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/utils/gaming_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

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
  const GameHistoryScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameHistoryCubit cubit = context.watch<GameHistoryCubit>();
    const Color cardBackgroundColor = Color(0xFF2A402A);

    final int playedRounds = calculatePlayedRounds(cubit.state.games);
    final int gameAmount = cubit.state.games.length;
    final String gameTime = calculateTotalPlayTime(cubit.state.games);
    final int totalCollectedPoints = calculateTotalPoints(cubit.state.games);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: CaboTheme.primaryColor,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 110,
                child: _headerCards(
                  playedRounds: playedRounds,
                  gameAmount: gameAmount,
                  backgroundColor: cardBackgroundColor,
                  gameTime: gameTime,
                  context: context,
                ),
              ),
              AnimatedTotalPointsBanner(
                totalCollectedPoints: totalCollectedPoints,
                backgroundColor: cardBackgroundColor,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: _generateList(cubit.state.games)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _generateList(List<Game> games) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < games.length; i++) {
      children.add(
        Padding(
          padding: i % 2 == 0
              ? const EdgeInsets.only(right: 50)
              : const EdgeInsets.only(left: 50),
          child: GameCard(game: games[i]),
        ),
      );
    }
    return children;
  }

  Widget _headerCards({
    int gameAmount = 0,
    int playedRounds = 0,
    String gameTime = '0 Days\n0 Hours', // Expecting newline separated string
    required BuildContext context,
    required Color backgroundColor,
  }) {
    // Parse gameTime string
    final gameTimeParts = gameTime.split('\n');
    final days = gameTimeParts.isNotEmpty ? gameTimeParts[0] : '0 Days';
    final hours = gameTimeParts.length > 1 ? gameTimeParts[1] : '0 Hours';

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align tops if heights differ
      children: [
        Expanded(
          child: _buildStatCard(
            icon: '🎮',
            valueWidget: AutoSizeText(
              '$gameAmount',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            label: AppLocalizations.of(context)!.historyScreenGamesCardTitle,
            backgroundColor: backgroundColor,
          ),
        ),
        const SizedBox(width: 16.0), // Gap between cards
        Expanded(
          child: _buildStatCard(
            icon: '⏰',
            valueWidget: Column(
              // Use Column for two lines
              children: [
                if (gameTimeParts.length > 1)
                  AutoSizeText(
                    days,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.0, // Smaller font for time
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                AutoSizeText(
                  hours,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0, // Smaller font for time
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            label: AppLocalizations.of(context)!.historyScreenGameTimeCardTitle,
            backgroundColor: backgroundColor,
          ),
        ),
        const SizedBox(width: 16.0), // Gap between cards
        Expanded(
          child: _buildStatCard(
            icon: '🏅',
            valueWidget: AutoSizeText(
              '$playedRounds',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            label: AppLocalizations.of(
              context,
            )!.historyScreenPlayedRoundsCardTitle,
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String icon,
    required Widget valueWidget,
    required String label,
    required Color backgroundColor,
    EdgeInsets padding = const EdgeInsets.all(0.0),
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 5.0,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              icon,
              style: const TextStyle(fontSize: 20.0, color: Colors.white),
            ),
            valueWidget,
            AutoSizeText(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.0, color: Colors.grey[300]),
            ),
          ],
        ),
      ),
    );
  }
}
