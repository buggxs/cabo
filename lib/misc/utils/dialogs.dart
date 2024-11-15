import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    borderSide: BorderSide(color: Color.fromRGBO(81, 120, 30, 1.0), width: 1),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(81, 120, 30, 1.0), width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(81, 120, 30, 1.0), width: 1),
  ),
  contentPadding: EdgeInsets.all(8.0),
  filled: true,
  fillColor: Color.fromRGBO(32, 45, 18, 1),
);

class StatisticsDialogService {
  Future<Map<String, int?>?> showPointDialog(
    List<Player>? players,
  ) {
    Map<String, int?> playerPointsMap = {};
    return app<NavigationService>().showAppDialog<Map<String, int?>>(
      dialog: (BuildContext context) => Dialog(
        backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.enterPointsDialogTitle,
                  style: title,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Aclonica',
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (String points) {
                                  playerPointsMap[player.name] =
                                      int.tryParse(points);
                                },
                                minLines: 1,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Aclonica',
                                  color: Color.fromRGBO(81, 120, 30, 1.0),
                                ),
                                decoration: dialogPointInputStyle,
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
                            Navigator.of(context).pop(playerPointsMap);
                          },
                          style: dialogButtonStyle,
                          child: Text(
                            AppLocalizations.of(context)!.enterDialogButton,
                            style: const TextStyle(
                              fontFamily: 'Aclonica',
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

  Future<bool?> showEndGame() {
    return app<NavigationService>().showAppDialog(
        dialog: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.finishCurrentGame,
                style: title,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: dialogButtonStyle,
                      child: Text(
                        AppLocalizations.of(context)!.finishGameDialogButton,
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          fontSize: 14,
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
                      style: dialogButtonStyle,
                      child: Text(
                        AppLocalizations.of(context)!.continueGameDialogButton,
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          fontSize: 14,
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
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(player);
                          },
                          child: AutoSizeText(
                            player.name,
                            style: const TextStyle(
                              fontFamily: 'Aclonica',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList() ??
            <OutlinedButton>[];
        return Dialog(
          backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.dialogTextRoundFinishedBy,
                  style: title,
                  textAlign: TextAlign.center,
                ),
                if (buttons.isNotEmpty) ...buttons
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
