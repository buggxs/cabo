import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/points_entry_sheet.dart';
import 'package:cabo/components/statistics/widgets/round_closer_sheet.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class StatisticsDialogService {
  Future<Map<String, int?>?> showPointDialog(
    List<Player>? players, {
    Player? closer,
  }) {
    final List<Player> playerList = players ?? const <Player>[];

    return app<NavigationService>().showAppModalBottomSheet<Map<String, int?>>(
      builder: (BuildContext context) =>
          PointsEntrySheet(players: playerList, closer: closer),
    );
  }

  Future<bool?> showEndGame(Game? game) {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;
        final (String title, String confirmLabel, IconData icon) =
            _endGameTexts(l10n, game);

        return _buildChoiceDialog(
          icon: icon,
          content: <Widget>[
            AutoSizeText(
              title,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
          confirmLabel: confirmLabel,
          cancelLabel: l10n.continueGameDialogButton,
        );
      },
    );
  }

  (String, String, IconData) _endGameTexts(AppLocalizations l10n, Game? game) {
    final String? uid = app<AuthService>().currentUser?.uid;
    final bool isPublic = game?.isPublic ?? false;
    final bool isOwner = isPublic && uid == game?.ownerId;

    if (isPublic && !isOwner) {
      return (
        l10n.leaveCurrentGame,
        l10n.leaveGameDialogButton,
        Icons.logout_rounded,
      );
    }
    if (isOwner) {
      return (
        l10n.finishCurrentGamePublic,
        l10n.finishGameDialogButton,
        Icons.flag_rounded,
      );
    }
    return (
      l10n.finishCurrentGame,
      l10n.finishGameDialogButton,
      Icons.flag_rounded,
    );
  }

  Future<Player?> showRoundCloserDialog({List<Player>? players}) {
    final List<Player> playerList = players ?? const <Player>[];

    return app<NavigationService>().showAppModalBottomSheet<Player>(
      builder: (BuildContext context) => RoundCloserSheet(players: playerList),
    );
  }

  Future<bool?> loadNotFinishedGame() async {
    return app<NavigationService>().showAppDialog<bool?>(
      dialog: (BuildContext context) {
        final AppLocalizations l10n = AppLocalizations.of(context)!;

        return _buildChoiceDialog(
          icon: Icons.history_rounded,
          content: <Widget>[
            Text(
              l10n.dialogTitleLoadFinishedGame,
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dialogTextLoadFinishedGame,
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          confirmLabel: l10n.loadGameDialogButton,
          cancelLabel: l10n.notLoadGameDialogButton,
        );
      },
    );
  }

  Dialog _buildChoiceDialog({
    required IconData icon,
    required List<Widget> content,
    required String confirmLabel,
    required String cancelLabel,
  }) {
    return Dialog(
      backgroundColor: CaboTheme.surfaceContainerLowest,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDialogIcon(icon),
            const SizedBox(height: 20),
            ...content,
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: CaboPrimaryButton(
                label: confirmLabel,
                onPressed: () => app<NavigationService>().pop(true),
              ),
            ),
            const SizedBox(height: 8),
            _buildCancelButton(cancelLabel),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogIcon(IconData icon) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: CaboTheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 32, color: CaboTheme.onPrimaryContainer),
    );
  }

  Widget _buildCancelButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => app<NavigationService>().pop(false),
        style: TextButton.styleFrom(
          foregroundColor: CaboTheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          ),
        ),
        child: Text(
          label,
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
