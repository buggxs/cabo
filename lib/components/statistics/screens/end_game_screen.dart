import 'dart:async';

import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/main_menu/screens/main_menu_screen.dart';
import 'package:cabo/components/statistics/widgets/end_game_detailed_stats_card.dart';
import 'package:cabo/components/statistics/widgets/end_game_highlights_card.dart';
import 'package:cabo/components/statistics/widgets/end_game_ranking_card.dart';
import 'package:cabo/components/statistics/widgets/end_game_summary_row.dart';
import 'package:cabo/components/statistics/widgets/end_game_winner_card.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/rating/rating_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

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
                    children: _buildContent(ranked, winner),
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

  List<Widget> _buildContent(List<Player> ranked, Player? winner) {
    return <Widget>[
      Text(
        context.l10n.winnerDialogTitle,
        textAlign: TextAlign.center,
        style: CaboTheme.displayLargeStyle.copyWith(color: CaboTheme.m3Primary),
      ),
      const SizedBox(height: 24),
      if (winner != null) EndGameWinnerCard(winner: winner),
      const SizedBox(height: 24),
      EndGameSummaryRow(
        game: widget.game,
        roundCount: ranked.firstOrNull?.rounds.length ?? 0,
      ),
      const SizedBox(height: 32),
      _buildSectionLabel(context.l10n.endGameRankingTitle),
      const SizedBox(height: 8),
      EndGameRankingCard(rankedPlayers: ranked),
      const SizedBox(height: 32),
      _buildSectionLabel(context.l10n.endGameDetailedTitle),
      const SizedBox(height: 8),
      for (int i = 0; i < ranked.length; i++) ...<Widget>[
        EndGameDetailedStatsCard(player: ranked[i], isWinner: i == 0),
        if (i != ranked.length - 1) const SizedBox(height: 12),
      ],
      if (ranked.firstOrNull?.rounds.isNotEmpty ?? false) ...<Widget>[
        const SizedBox(height: 32),
        EndGameHighlightsCard(game: widget.game, rankedPlayers: ranked),
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: CaboTheme.labelSmallStyle.copyWith(
        color: CaboTheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}
