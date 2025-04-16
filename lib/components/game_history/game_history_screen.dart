import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/components/game_history/cubit/game_history_cubit.dart';
import 'package:cabo/components/game_history/widget/game_card.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/misc/utils/gaming_data.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  playedRounds: calculatePlayedRounds(
                    cubit.state.games,
                  ),
                  gameAmount: cubit.state.games.length,
                  backgroundColor: cardBackgroundColor,
                  gameTime: calculateTotalPlayTime(cubit.state.games),
                  context: context,
                ),
              ),
              _totalPointsBanner(
                totalCollectedPoints: calculateTotalPoints(
                  cubit.state.games,
                ),
                backgroundColor: cardBackgroundColor,
                context: context,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _generateList(cubit.state.games),
                  ),
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
          child: GameCard(
            game: games[i],
          ),
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
            label: AppLocalizations.of(context)!
                .historyScreenPlayedRoundsCardTitle,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
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
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalPointsBanner({
    int totalCollectedPoints = 0,
    required BuildContext context,
    required Color backgroundColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildStatCard(
            icon: '⭐',
            valueWidget: Text(
              '$totalCollectedPoints',
              style: const TextStyle(
                fontSize: 34.0, // Larger font for total points
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            label: AppLocalizations.of(context)!.historyScreenTotalPointsTitle,
            backgroundColor: backgroundColor,
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 0,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 8,
            ), // Larger padding for banner
          ),
        ),
      ],
    );
  }
}
