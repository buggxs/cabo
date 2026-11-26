import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/auth/widgets/auth_form.dart';
import 'package:cabo/components/statistics/widgets/loading_spinner_section.dart';
import 'package:cabo/components/statistics/widgets/publish_game_section.dart';
import 'package:cabo/components/statistics/widgets/qr_code_section.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/utils/logger.dart';
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

    if (applicationCubit.state.canPublishGame || _publicGameId != null) {
      child = buildAuthenticatedView(context);
    }

    return Scaffold(
      backgroundColor: CaboTheme.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: CaboTheme.scaffoldBackground,
        leading: IconButton(
          icon: Icon(Icons.close, color: CaboTheme.m3Primary),
          onPressed: () => app<NavigationService>().pop(false),
        ),
        title: Text(
          AppLocalizations.of(context)!.publishDialogTitle,
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
            constraints: const BoxConstraints(maxWidth: 448),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget buildAuthenticatedView(BuildContext context) {
    Widget currentView;

    if (_publicGameId != null) {
      currentView = QrCodeSection(
        gameId: _publicGameId!,
        ownerId: _game?.ownerId,
        onContinue: () => app<NavigationService>().pop(true),
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
    } on Exception catch (e) {
      setState(() {
        _isPublishing = false;
      });
      logger.severe('Failed to publish game', e);
      _showPublishFailedSnackBar();
      return;
    }

    if (publicGame?.publicId != null && mounted) {
      await _showPublishedGame(publicGame!);
    } else {
      setState(() {
        _isPublishing = false;
      });
      _showPublishFailedSnackBar();
    }
  }

  Future<void> _showPublishedGame(Game publicGame) async {
    setState(() {
      _isPreparing = true;
      _isPublishing = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _publicGameId = publicGame.publicId;
        _game = publicGame;
      });
    }
  }

  void _showPublishFailedSnackBar() {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.publishDialogFailedToPublish),
        backgroundColor: CaboTheme.m3Error,
      ),
    );
  }
}
