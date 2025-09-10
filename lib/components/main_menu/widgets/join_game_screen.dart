import 'package:cabo/components/main_menu/widgets/cabo_scanner_window.dart';
import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/widgets/cabo_text_field.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  Game? _publicGame;
  bool _isLoading = false;
  String? _scannedQrCode;
  String? _loadingStatusText;
  bool _showManualInput = false;
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 24,
            color: CaboTheme.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.menuEntryJoinGame,
          style: CaboTheme.primaryTextStyle.copyWith(fontSize: 38),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: DarkScreenOverlay(
          darken: 0.70,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _showManualInput
                      ? _buildManualInput()
                      : CaboScannerWindow(
                          onDetectPublicId: _retrieveQrCodeData,
                        ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showManualInput = !_showManualInput;
                    });
                  },
                  child: Text(
                    _showManualInput
                        ? 'QR-Code scannen'
                        : 'Stattdessen ID eingeben',
                    style: const TextStyle(
                      color: CaboTheme.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: CaboTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildGameInfo(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MenuButton(
                    text: AppLocalizations.of(context)!.loadGameDialogButton,
                    onTap: (_publicGame != null && !_isLoading)
                        ? () => app<NavigationService>().pushToStatsScreen(
                            players: _publicGame!.players,
                            game: _publicGame,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildManualInput() {
    Color currentBackgroundColor = CaboTheme.tertiaryColor;

    return Padding(
      key: const ValueKey('manual-input'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          CaboTextFormField(
            controller: _idController,
            labelText: 'Game ID (z.B. cabo-123-xyz)',
          ),
          const SizedBox(height: 20),
          MenuButton(
            text: 'Suchen',
            onTap: () => _retrieveQrCodeData(_idController.text),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfo() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: CaboTheme.primaryColor),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                _loadingStatusText ?? '',
                key: ValueKey<String>(_loadingStatusText ?? ''),
                textAlign: TextAlign.center,
                style: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    }

    if (_publicGame != null) {
      return _buildGameDetails(_publicGame!);
    }

    return Center(
      child: Text(
        _showManualInput
            ? 'Gebe die Spiele-ID ein, um einem Spiel beizutreten.'
            : AppLocalizations.of(context)!.joinGameScreenScanToJoin,
        textAlign: TextAlign.center,
        style: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildGameDetails(Game game) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CaboTheme.secondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: CaboTheme.tertiaryColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.joinGameScreenGameFound,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)!.joinGameScreenGameRounds}: ${game.players.firstOrNull?.rounds.length ?? 0}',
            textAlign: TextAlign.center,
            style: CaboTheme.secondaryTextStyle.copyWith(
              fontSize: 18,
              color: CaboTheme.primaryGreenColor,
            ),
          ),
          const Divider(
            color: CaboTheme.tertiaryColor,
            thickness: 1,
            height: 30,
          ),
          SingleChildScrollView(
            child: Column(
              children: game.players
                  .map(
                    (player) => ListTile(
                      title: Text(
                        player.name,
                        style: CaboTheme.primaryTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      trailing: Text(
                        '${player.totalPoints} ${AppLocalizations.of(context)!.joinGameScreenGamePoints}',
                        style: CaboTheme.secondaryTextStyle.copyWith(
                          fontSize: 20,
                          color: CaboTheme.primaryGreenColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _retrieveQrCodeData(String? qrCode) async {
    // Verhindert mehrfaches Ausführen für denselben QR-Code
    if (qrCode == null || qrCode.isEmpty || qrCode == _scannedQrCode) {
      return;
    }

    setState(() {
      _isLoading = true;
      _scannedQrCode = qrCode;
      _publicGame = null;
      _loadingStatusText = AppLocalizations.of(
        context,
      )!.joinGameScreenLoadingStatus;
    });

    // Kurze Pause, damit der Benutzer den ersten Schritt sieht
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) {
      return;
    }

    setState(() {
      _loadingStatusText = AppLocalizations.of(
        context,
      )!.joinGameScreenSearchingGame;
    });

    try {
      final Game publicGame = await app<PublicGameService>().getPublicGame(
        qrCode,
      );

      if (mounted) {
        setState(() {
          _publicGame = publicGame;
          _isLoading = false;
          _loadingStatusText = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _scannedQrCode = null; // Erlaube erneutes Scannen nach einem Fehler
          _loadingStatusText = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.joinGameScreenGameNotFound,
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
