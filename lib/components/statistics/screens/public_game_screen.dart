import 'package:cabo/common/presentation/screens/cabo_default_view.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/statistics/widgets/auth_form.dart';
import 'package:cabo/components/statistics/widgets/loading_spinner_section.dart';
import 'package:cabo/components/statistics/widgets/publish_game_section.dart';
import 'package:cabo/components/statistics/widgets/qr_code_section.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _PublicGameScreenState extends State<PublicGameScreen> with LoggerMixin {
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
    final ApplicationCubit applicationCubit = context.watch<ApplicationCubit>();

    Widget child = const AuthForm();

    if ((applicationCubit.state is ApplicationAuthenticated &&
            !(FirebaseAuth.instance.currentUser?.isAnonymous ?? true)) ||
        _publicGameId != null) {
      child = buildAuthenticatedView(context);
    }

    return CaboDefaultView(
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
      useOverlay: true,
      child: child,
    );
  }

  Widget buildAuthenticatedView(BuildContext context) {
    Widget currentView;

    if (_publicGameId != null) {
      currentView = QrCodeSection(
        gameId: _publicGameId!,
        ownerId: _game?.ownerId,
      );
    } else if (_isPreparing) {
      currentView = LoadingSpinnerSection(
        loadingText: AppLocalizations.of(context)!.publishDialogLoading,
      );
    } else {
      currentView = PublishGameSection(
        onPublish: handlePublishGame,
        isPublishing: _isPublishing,
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: currentView,
    );
  }

  Future<void> handlePublishGame() async {
    setState(() {
      _isPublishing = true;
    });

    final Game? publicGame;
    try {
      publicGame = await widget.publishGame();
    } catch (e) {
      setState(() {
        _isPublishing = false;
      });
      if (e is FirebaseException) {
        logger.severe('Firebase error: ${e.message}', e);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.publishDialogFailedToPublish),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

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
