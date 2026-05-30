import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/points_entry_sheet.dart';
import 'package:cabo/components/statistics/widgets/round_closer_sheet.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color primaryColor = CaboTheme.primaryColor;
const Color secondaryColor = CaboTheme.secondaryColor;
const Color dialogBorderColor = Color.fromRGBO(81, 120, 30, 1);

const TextStyle title = TextStyle(
  fontFamily: 'Archivo',
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(142, 215, 46, 1.0),
);

const TextStyle primaryButtonTextStyle = TextStyle(
  fontFamily: 'Archivo',
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color.fromRGBO(185, 206, 1, 1.0),
);

const TextStyle secondaryButtonTextStyle = TextStyle(
  fontFamily: 'Archivo',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Color.fromRGBO(80, 119, 30, 1.0),
);

final ButtonStyle primaryButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: primaryColor,
  side: const BorderSide(color: primaryColor, width: 2.0),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
);

final RoundedRectangleBorder dialogBorderShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(5),
  side: const BorderSide(
    style: BorderStyle.solid,
    color: dialogBorderColor,
    width: 2,
  ),
);

const InputDecoration inputDecoration = InputDecoration(
  border: InputBorder.none,
);

final ButtonStyle dialogButtonStyle = OutlinedButton.styleFrom(
  foregroundColor: Colors.black,
  side: const BorderSide(color: Colors.black),
);

const InputDecoration dialogPointInputStyle = InputDecoration(
  isDense: true,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: CaboTheme.tertiaryColor, width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CaboTheme.tertiaryColor, width: 2),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: CaboTheme.tertiaryColor, width: 2),
    gapPadding: 0,
  ),
  contentPadding: EdgeInsets.all(8.0),
  filled: true,
  fillColor: CaboTheme.secondaryColor,
);

class StatisticsDialogService {
  Future<Map<String, int?>?> showPointDialog(List<Player>? players) {
    final List<Player> playerList = players ?? const <Player>[];

    return app<NavigationService>().showAppModalBottomSheet<Map<String, int?>>(
      builder: (BuildContext context) => PointsEntrySheet(players: playerList),
    );
  }

  Future<bool?> showEndGame(Game? game) {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) {
        final String? uid = FirebaseAuth.instance.currentUser?.uid;
        final bool isPublic = game?.isPublic ?? false;
        final bool isOwner = isPublic && uid == game?.ownerId;
        final bool isNonOwnerPublic = isPublic && !isOwner;

        final String title;
        final String confirmLabel;
        if (isNonOwnerPublic) {
          title = AppLocalizations.of(context)!.leaveCurrentGame;
          confirmLabel = AppLocalizations.of(context)!.leaveGameDialogButton;
        } else if (isOwner) {
          title = AppLocalizations.of(context)!.finishCurrentGamePublic;
          confirmLabel = AppLocalizations.of(context)!.finishGameDialogButton;
        } else {
          title = AppLocalizations.of(context)!.finishCurrentGame;
          confirmLabel = AppLocalizations.of(context)!.finishGameDialogButton;
        }

        return Dialog(
          shape: dialogBorderShape,
          backgroundColor: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AutoSizeText(
                  title,
                  style: CaboTheme.primaryTextStyle.copyWith(
                    color: CaboTheme.primaryGreenColor,
                    fontFamily: 'Archivo Black',
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: primaryButtonStyle,
                        child: Text(
                          confirmLabel,
                          style: CaboTheme.primaryTextStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: primaryButtonStyle,
                        child: AutoSizeText(
                          AppLocalizations.of(
                            context,
                          )!.continueGameDialogButton,
                          style: CaboTheme.secondaryTextStyle.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: CaboTheme.tertiaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

        return Dialog(
          backgroundColor: CaboTheme.surfaceContainerLowest,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: CaboTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.history_rounded,
                    size: 32,
                    color: CaboTheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: CaboPrimaryButton(
                    label: l10n.loadGameDialogButton,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      foregroundColor: CaboTheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          CaboTheme.cardRadius,
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.notLoadGameDialogButton,
                      style: CaboTheme.labelLargeStyle.copyWith(
                        color: CaboTheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
