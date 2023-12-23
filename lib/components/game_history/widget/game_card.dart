import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    Key? key,
    required this.game,
  }) : super(key: key);

  final TextStyle style = const TextStyle(
    fontSize: 18,
    fontFamily: 'Aclonica',
  );

  final Game game;

  @override
  Widget build(BuildContext context) {
    final String locale = Localizations.localeOf(context).languageCode;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
      color: const Color.fromRGBO(81, 120, 30, 0.6),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(game.date(locale)),
                Text(game.gameDuration),
              ],
            ),
            Wrap(
              children: _buildPlayerAndPoints(game),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlayerAndPoints(Game game) {
    List<Widget> children = <Widget>[];

    for (Player player in game.players) {
      children
        ..add(Text(
          '${player.name}: ${player.totalPoints}',
          style: style,
        ))
        ..add(const SizedBox(
          width: 25,
        ));
    }

    return children;
  }
}
