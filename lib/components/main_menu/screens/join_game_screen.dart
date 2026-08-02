import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/main_menu/widgets/cabo_scanner_window.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/public_game_service.dart';
import 'package:cabo/l10n/app_localizations.dart';
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
  static const String _idPrefix = 'cabo-';
  final TextEditingController _idController = TextEditingController(
    text: _idPrefix,
  )..selection = const TextSelection.collapsed(offset: _idPrefix.length);

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CaboTheme.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CaboTheme.m3Primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.menuEntryJoinGame,
          style: CaboTheme.headlineMediumStyle.copyWith(
            color: CaboTheme.m3Primary,
            fontWeight: FontWeight.bold,
          ),
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
                _buildScannerSection(l10n),
                const SizedBox(height: 24),
                _buildOrDivider(l10n),
                const SizedBox(height: 24),
                _buildManualInput(l10n),
                const SizedBox(height: 24),
                _buildGameInfo(l10n),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildJoinButton(l10n),
    );
  }

  Widget _buildScannerSection(AppLocalizations l10n) {
    return Column(
      children: <Widget>[
        Center(child: CaboScannerWindow(onDetectPublicId: _retrieveQrCodeData)),
        const SizedBox(height: 16),
        Text(
          l10n.joinGameScreenScanToJoin,
          textAlign: TextAlign.center,
          style: CaboTheme.bodyMediumStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildOrDivider(AppLocalizations l10n) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: CaboTheme.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.joinGameScreenOrDivider,
            style: CaboTheme.labelLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Expanded(child: Divider(color: CaboTheme.outlineVariant)),
      ],
    );
  }

  Widget _buildManualInput(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            l10n.joinGameScreenManualLabel,
            style: CaboTheme.labelLargeStyle.copyWith(
              color: CaboTheme.m3Primary,
            ),
          ),
        ),
        TextField(
          controller: _idController,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor: CaboTheme.m3Primary,
          style: CaboTheme.bodyLargeStyle.copyWith(color: CaboTheme.onSurface),
          decoration: InputDecoration(
            hintText: l10n.joinGameScreenGameIdLabel,
            hintStyle: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.outlineVariant,
            ),
            filled: true,
            fillColor: CaboTheme.surfaceContainer,
            suffixIcon: Icon(Icons.edit, color: CaboTheme.outline),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
              borderSide: BorderSide(color: CaboTheme.m3Primary, width: 2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 4),
          child: Text(
            l10n.joinGameScreenEnterIdToJoin,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameInfo(AppLocalizations l10n) {
    if (_isLoading) {
      return Center(
        child: Column(
          children: <Widget>[
            CircularProgressIndicator(color: CaboTheme.m3Primary),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                _loadingStatusText ?? '',
                key: ValueKey<String>(_loadingStatusText ?? ''),
                textAlign: TextAlign.center,
                style: CaboTheme.bodyLargeStyle.copyWith(
                  color: CaboTheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_publicGame != null) {
      return _buildGameDetails(l10n, _publicGame!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildGameDetails(AppLocalizations l10n, Game game) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.joinGameScreenGameFound,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.m3Primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.joinGameScreenGameRounds}: ${game.players.firstOrNull?.rounds.length ?? 0}',
            textAlign: TextAlign.center,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.m3Secondary,
            ),
          ),
          Divider(color: CaboTheme.outlineVariant, thickness: 1, height: 30),
          ...game.players.map(
            (player) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                player.name,
                style: CaboTheme.bodyLargeStyle.copyWith(
                  color: CaboTheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                '${player.totalPoints} ${l10n.joinGameScreenGamePoints}',
                style: CaboTheme.bodyLargeStyle.copyWith(
                  color: CaboTheme.m3Secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(AppLocalizations l10n) {
    final VoidCallback? onPressed;
    if (_isLoading) {
      onPressed = null;
    } else if (_publicGame != null) {
      onPressed = () => app<NavigationService>().pushToStatsScreen(
        players: _publicGame!.players,
        game: _publicGame,
      );
    } else {
      onPressed = () {
        FocusScope.of(context).unfocus();
        _retrieveQrCodeData(_idController.text);
      };
    }

    final String label = _publicGame != null
        ? l10n.joinGameScreenJoinButton
        : l10n.joinGameScreenSearchGameButton;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: CaboPrimaryButton(
          label: label,
          leading: Icon(Icons.login, color: CaboTheme.onPrimaryContainer),
          onPressed: onPressed,
        ),
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
      Game publicGame = await app<PublicGameService>().getPublicGame(qrCode);

      if (publicGame.isGameFinished) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _scannedQrCode = null;
            _loadingStatusText = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.joinGameScreenGameAlreadyFinished,
              ),
              backgroundColor: CaboTheme.m3Error,
            ),
          );
        }
        return;
      }

      // joinGame registriert die UID des Mitspielers (ggf. via Anonymous-Auth)
      // im Firestore-Dokument — Voraussetzung für die Security Rules und
      // dafür, dass Punkte-Updates akzeptiert werden.
      publicGame = await app<PublicGameService>().joinGame(qrCode);

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
            backgroundColor: CaboTheme.m3Error,
          ),
        );
      }
    }
  }
}
