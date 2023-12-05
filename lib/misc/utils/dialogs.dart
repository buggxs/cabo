import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

const TextStyle title = TextStyle(
  fontFamily: 'Aclonica',
  fontSize: 20,
);

const InputDecoration inputDecoration = InputDecoration(
  border: InputBorder.none,
);

final ButtonStyle dialogButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.black,
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
  fillColor: Color.fromRGBO(32, 45, 18, 0.75),
);

class StatisticsDialogService {
  Future<Map<String, int?>?> showPointDialog(
    List<Player>? players,
  ) {
    Map<String, int?> playerPointsMap = {};
    return app<NavigationService>().showAppDialog<Map<String, int?>>(
      dialog: (BuildContext context) => Dialog(
        backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Aclonica',
                            ),
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
                              ),
                              decoration: dialogPointInputStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              OutlinedButton(
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
            ],
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
        backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: dialogButtonStyle,
                        child: const Text(
                          'Nein, weiter spielen.',
                          style:
                              TextStyle(fontFamily: 'Aclonica', fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: dialogButtonStyle,
                        child: const Text(
                          'Ja, beenden!',
                          style:
                              TextStyle(fontFamily: 'Aclonica', fontSize: 14),
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
    );
  }

  Future<Player?> showRoundCloserDialog({
    List<Player>? players,
  }) {
    return app<NavigationService>().showAppDialog(
        dialog: (BuildContext context) {
      List<OutlinedButton> buttons = players
              ?.map(
                (Player player) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(player);
                  },
                  child: Text(
                    player.name,
                    style: const TextStyle(
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              )
              .toList() ??
          <OutlinedButton>[];
      return Dialog(
        backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Wer hat die Runde beendet?',
                style: TextStyle(
                  fontFamily: 'Aclonica',
                  fontSize: 18,
                ),
              ),
              if (buttons.isNotEmpty) ...buttons
            ],
          ),
        ),
      );
    });
  }
}
