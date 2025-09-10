import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/components/statistics/widgets/auth_form.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PublicGameScreen extends StatefulWidget {
  const PublicGameScreen({
    super.key,
    required this.publishGame,
    this.gameId,
    this.game,
  });

  final Future<Game?> Function() publishGame;
  final String? gameId;
  final Game? game;

  @override
  State<PublicGameScreen> createState() => _PublicGameScreenState();
}

class _PublicGameScreenState extends State<PublicGameScreen> {
  String? _publicGameId;
  bool _isPreparing = false;
  bool _isPublishing = false;
  Game? _game;

  @override
  void initState() {
    super.initState();
    if (widget.gameId != null) {
      _publicGameId = widget.gameId;
    }
    _game = widget.game;
  }

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
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Text(
          AppLocalizations.of(context)!.publishDialogTitle,
          style: CaboTheme.primaryTextStyle,
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
            child: BlocBuilder<ApplicationCubit, ApplicationState>(
              builder: (context, state) {
                if ((state is ApplicationAuthenticated &&
                        !(FirebaseAuth.instance.currentUser?.isAnonymous ??
                            true)) ||
                    _publicGameId != null) {
                  return _buildAuthenticatedView(context);
                } else {
                  return const AuthForm();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context) {
    Widget currentView;

    if (_publicGameId != null) {
      currentView = _buildQrCodeView(context, _publicGameId!);
    } else if (_isPreparing) {
      currentView = _buildLoadingView();
    } else {
      currentView = _buildPublishButtonView(context);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: currentView,
    );
  }

  Widget _buildLoadingView() {
    return Column(
      key: const ValueKey<String>('loading-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(color: CaboTheme.primaryColor),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context)!.publishDialogLoading,
          textAlign: TextAlign.center,
          style: CaboTheme.primaryTextStyle.copyWith(fontSize: 22),
        ),
      ],
    );
  }

  Widget _buildQrCodeView(BuildContext context, String gameId) {
    QrCode qrCode = QrCode.fromData(
      data: gameId,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    final QrImage qrImage = QrImage(qrCode);

    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      key: const ValueKey<String>('qr-code-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.greenAccent,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          userId != _game?.ownerId
              ? AppLocalizations.of(context)!.publishDialogJoinedGame
              : AppLocalizations.of(context)!.publishDialogGamePublished,
          textAlign: TextAlign.center,
          style: CaboTheme.primaryTextStyle.copyWith(fontSize: 26),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context)!.publishDialogFriendsCanJoin,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 22),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: 200,
          height: 200,
          child: PrettyQrView(qrImage: qrImage),
        ),
        const SizedBox(height: 16),
        Text(
          gameId,
          style: CaboTheme.secondaryTextStyle.copyWith(
            fontSize: 20,
            color: CaboTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPublishButtonView(BuildContext context) {
    return Column(
      key: const ValueKey<String>('publish-button-view'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations.of(context)!.publishDialogReadyToPublish,
            textAlign: TextAlign.center,
            style: CaboTheme.primaryTextStyle.copyWith(fontSize: 26),
          ),
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: AppLocalizations.of(context)!.publishDialogPublish,
          onTap: _isPublishing ? null : _handlePublishGame,
          textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  Future<void> _handlePublishGame() async {
    setState(() {
      _isPublishing = true;
    });

    final Game? publicGame = await widget.publishGame();

    if (publicGame?.publicId != null && mounted) {
      setState(() {
        _isPreparing = true;
        _isPublishing = false;
      });

      await Future<void>.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _publicGameId = publicGame!.publicId;
          _game = publicGame;
        });
      }
    } else {
      setState(() {
        _isPublishing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.publishDialogFailedToPublish,
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
