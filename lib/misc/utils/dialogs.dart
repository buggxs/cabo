import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
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
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.0),
  ),
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
  side: const BorderSide(
    color: Colors.black,
  ),
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
  Future<Map<String, int?>?> showPointDialog(
    List<Player>? players,
  ) {
    Map<String, int?> playerPointsMap = {};
    final Map<String, FocusNode> focusNodes = {};

    // Create focus nodes for each player
    players?.forEach((player) {
      focusNodes[player.name] = FocusNode();
    });

    return app<NavigationService>().showAppDialog<Map<String, int?>>(
      dialog: (BuildContext context) => Dialog(
        shape: dialogBorderShape,
        backgroundColor: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.enterPointsDialogTitle,
                  style: CaboTheme.primaryTextStyle.copyWith(
                    color: CaboTheme.primaryGreenColor,
                    fontFamily: 'Archivo Black',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                ...?players
                    ?.map(
                      (Player player) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              player.name,
                              style: CaboTheme.primaryTextStyle.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                focusNode: focusNodes[player.name],
                                keyboardType: TextInputType.number,
                                onChanged: (String points) {
                                  playerPointsMap[player.name] =
                                      int.tryParse(points);
                                },
                                minLines: 1,
                                style: CaboTheme.numberTextStyle.copyWith(
                                  color: CaboTheme.primaryColor,
                                  fontSize: 20,
                                ),
                                decoration: dialogPointInputStyle.copyWith(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  labelText: AppLocalizations.of(context)!
                                      .dialogPointsLabel,
                                  labelStyle:
                                      CaboTheme.secondaryTextStyle.copyWith(
                                    color: CaboTheme.primaryColor.withAlpha(
                                      100,
                                    ),
                                    fontFamily: 'Aclonica',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            // Unfocus and dispose before popping
                            for (var node in focusNodes.values) {
                              if (node.hasFocus) {
                                node.unfocus();
                              }
                              node.dispose();
                            }
                            Navigator.of(context).pop(playerPointsMap);
                          },
                          style: primaryButtonStyle,
                          child: Text(
                            AppLocalizations.of(context)!.enterDialogButton,
                            style: CaboTheme.primaryTextStyle.copyWith(
                              fontWeight: FontWeight.w900,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showEndGame(Game? game) {
    return app<NavigationService>().showAppDialog(
        dialog: (BuildContext context) {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      return Dialog(
        shape: dialogBorderShape,
        backgroundColor: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AutoSizeText(
                AppLocalizations.of(context)!.finishCurrentGame,
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
                        uid == game?.ownerId
                            ? AppLocalizations.of(context)!
                                .finishGameDialogButton
                            : AppLocalizations.of(context)!
                                .leaveGameDialogButton,
                        style: CaboTheme.primaryTextStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: primaryButtonStyle,
                      child: AutoSizeText(
                        AppLocalizations.of(context)!.continueGameDialogButton,
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
    });
  }

  Future<Player?> showRoundCloserDialog({
    List<Player>? players,
  }) {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) {
        List<Widget> buttons = players
                ?.map(
                  (Player player) => Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: primaryButtonStyle,
                          onPressed: () {
                            Navigator.of(context).pop(player);
                          },
                          child: AutoSizeText(
                            player.name,
                            style: CaboTheme.primaryTextStyle.copyWith(
                              fontWeight: FontWeight.w900,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList() ??
            <OutlinedButton>[];
        return Dialog(
          shape: dialogBorderShape,
          backgroundColor: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AutoSizeText(
                  maxLines: 2,
                  AppLocalizations.of(context)!.dialogTextRoundFinishedBy,
                  style: CaboTheme.primaryTextStyle.copyWith(
                    color: CaboTheme.primaryGreenColor,
                    fontFamily: 'Archivo Black',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (buttons.isNotEmpty)
                  ...buttons.map(
                    (Widget button) => Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: button,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> loadNotFinishedGame() async {
    return app<NavigationService>().showAppDialog<bool?>(
      dialog: (BuildContext context) => Dialog(
        shape: dialogBorderShape,
        backgroundColor: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.dialogTitleLoadFinishedGame,
                style: title.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.dialogTextLoadFinishedGame,
                style: title.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
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
                        AppLocalizations.of(context)!.loadGameDialogButton,
                        style: primaryButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: primaryButtonStyle,
                      child: Text(
                        AppLocalizations.of(context)!.notLoadGameDialogButton,
                        style: secondaryButtonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
