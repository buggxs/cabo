import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class WinnerDialog extends StatefulWidget {
  const WinnerDialog({
    super.key,
    required this.winner,
    this.onConfirm,
  });

  final Player winner;
  final void Function()? onConfirm;

  @override
  State<WinnerDialog> createState() => _WinnerDialogState();
}

class _WinnerDialogState extends State<WinnerDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );

    // Start the confetti animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Confetti emitter positioned at the top center of the dialog
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                CaboTheme.primaryColor,
                CaboTheme.primaryGreenColor,
                CaboTheme.fourthColor,
                CaboTheme.firstPlaceColor,
                Colors.white,
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)?.winnerDialogTitle ??
                        'Game Over!',
                    style: CaboTheme.primaryTextStyle.copyWith(
                      fontSize: 28,
                      color: CaboTheme.primaryGreenColor,
                      fontFamily: 'Archivo Black',
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Image(
                    image: AssetImage('assets/icon/winner_trophy.png'),
                    width: 80,
                  ),
                  const SizedBox(height: 16),
                  AutoSizeText(
                    '${widget.winner.name} ${AppLocalizations.of(context)?.hasWonText ?? 'has won!'}',
                    style: CaboTheme.primaryTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)?.withPointsText ?? 'with'} ${widget.winner.totalPoints} ${AppLocalizations.of(context)?.pointsText ?? 'points'}',
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      fontSize: 18,
                      color: CaboTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CaboTheme.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: CaboTheme.primaryColorLight,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.okButton ?? 'OK',
                        style: CaboTheme.primaryTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
