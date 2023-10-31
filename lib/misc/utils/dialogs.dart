import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

const TextStyle title = TextStyle(
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
  fontSize: 24,
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
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.all(8.0),
);

Future<Player?> showRoundCloserDialog({
  required BuildContext context,
  List<Player>? players,
}) {
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
              child: Text(player.name),
            ),
          )
          .toList() ??
      <OutlinedButton>[];

  return showDialog<Player>(
    context: context,
    builder: (BuildContext context) => Dialog(
      backgroundColor: const Color.fromRGBO(163, 255, 163, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Wer hat die Runde beendet?',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            if (buttons.isNotEmpty) ...buttons
          ],
        ),
      ),
    ),
  );
}

Future<Map<String, int?>?> showPointDialog(
    BuildContext context, List<Player>? players) {
  Map<String, int?> playerPointsMap = {};
  return showDialog<Map<String, int?>>(
    context: context,
    builder: (BuildContext context) => Dialog(
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
                            style: const TextStyle(fontSize: 18),
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
              child: const Text('Eintragen'),
            ),
          ],
        ),
      ),
    ),
  );
}
