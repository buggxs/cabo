import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

const TextStyle title = TextStyle(
  fontFamily: 'Aclonica',
  fontSize: 20,
  color: Colors.black,
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
                const Text(
                  'Punkte eintragen',
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
                          child: const Text(
                            'Eintragen',
                            style: TextStyle(
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

  Future<bool?> showEndGame(
    BuildContext context,
  ) {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Möchtest du das Spiel wirklich beenden?',
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
                      child: const Text(
                        'Ja, beenden!',
                        style: TextStyle(fontFamily: 'Aclonica', fontSize: 14),
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
                      child: const Text(
                        'Nein, weiter spielen.',
                        style: TextStyle(fontFamily: 'Aclonica', fontSize: 14),
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
                const Text(
                  'Wer hat die Runde beendet?',
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
        backgroundColor: const Color.fromRGBO(81, 120, 30, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Du hast das letzt Spiel nicht beendet, soll es geladen werden?',
                style: title,
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      style: dialogButtonStyle,
                      child: const Text(
                        'Ja, Spiel laden!',
                        style: TextStyle(fontFamily: 'Aclonica', fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      style: dialogButtonStyle,
                      child: const Text(
                        'Nein, nicht laden.',
                        style: TextStyle(fontFamily: 'Aclonica', fontSize: 14),
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
