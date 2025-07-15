import 'package:cabo/components/main_menu/widgets/cabo_scanner_window.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  Game? _publicGame;
  bool _isLoading = false;
  String? _scannedQrCode;

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
          style: CaboTheme.secondaryTextStyle.copyWith(
            fontSize: 38,
          ),
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
        child: SafeArea(
          child: Column(
            children: [
              CaboScannerWindow(
                onDetectPublicId: _retrieveQrCodeData,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildGameInfo(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MenuButton(
                  text: 'Spiel laden',
                  onTap: _publicGame != null
                      ? () {
                          // TODO: Implementiere hier die Logik, um das Spiel zu laden und zur Spielansicht zu navigieren.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Spiellogik noch nicht implementiert.'),
                              backgroundColor: Colors.orangeAccent,
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameInfo() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: CaboTheme.primaryColor,
        ),
      );
    }

    if (_publicGame != null) {
      return _buildGameDetails(_publicGame!);
    }

    return Center(
      child: Text(
        'Scanne einen QR-Code, um einem Spiel beizutreten.',
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
            'Spiel gefunden!',
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'Runden: ${game.players.firstOrNull?.rounds.length ?? 0}',
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
          Expanded(
            child: ListView.builder(
              itemCount: game.players.length,
              itemBuilder: (context, index) {
                final player = game.players[index];
                return ListTile(
                  title: Text(
                    player.name,
                    style: CaboTheme.primaryTextStyle.copyWith(fontSize: 20),
                  ),
                  trailing: Text(
                    '${player.totalPoints} Punkte',
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      fontSize: 20,
                      color: CaboTheme.primaryGreenColor,
                    ),
                  ),
                );
              },
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
    });

    try {
      final Game publicGame =
          await app<PublicGameService>().getPublicGame(qrCode);

      if (mounted) {
        setState(() {
          _publicGame = publicGame;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _scannedQrCode = null; // Erlaube erneutes Scannen nach einem Fehler
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Spiel mit der ID "$qrCode" konnte nicht gefunden werden.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
