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
        side:
            const BorderSide(color: Color.fromRGBO(32, 45, 18, 0.9), width: 2),
      ),
      margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
      color: const Color.fromRGBO(81, 120, 30, 0.75),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.today,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      game.dateToString(),
                      style: style.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.timelapse,
                      size: 12,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      game.gameDuration,
                      style: style.copyWith(fontSize: 12),
                    ),
                  ],
                ),
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
