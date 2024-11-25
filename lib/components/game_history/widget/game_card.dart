import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
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
    return SizedBox(
      width: 380,
      child: Card(
        margin: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
        color: CaboTheme.secondaryBackgroundColor,
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
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        game.dateToString(),
                        style: CaboTheme.numberTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.timelapse,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        game.gameDuration,
                        style: CaboTheme.numberTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _buildPlayerAndPoints(game),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlayerAndPoints(Game game) {
    List<Widget> children = <Widget>[];

    for (Player player in game.players) {
      if (player.place == 3) {
        children.insert(
            0,
            SizedBox(
              width: 90,
              child: Column(
                children: [
                  AutoSizeText(
                    player.name,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.fourthColor,
                      shadows: CaboTheme().textStroke(Colors.black),
                    ),
                  ),
                  Container(
                    height: _containerPlacementHeight(player.place),
                    width: 90,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: _containerPlacementColor(player.place),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        textAlign: TextAlign.center,
                        '${player.totalPoints}',
                        style: CaboTheme.numberTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                          height: 0.77,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
      } else {
        children.add(SizedBox(
          width: 90,
          child: Column(
            children: [
              AutoSizeText(
                player.name,
                style: CaboTheme.secondaryTextStyle.copyWith(
                  color: CaboTheme.fourthColor,
                  shadows: CaboTheme().textStroke(Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                height: _containerPlacementHeight(player.place),
                width: 90,
                decoration: BoxDecoration(
                  color: _containerPlacementColor(player.place),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    if (player.place == 1)
                      const Image(
                        image: AssetImage('assets/icon/winner_trophy.png'),
                        width: 40,
                      ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '${player.totalPoints}',
                        textAlign: TextAlign.center,
                        style: CaboTheme.numberTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                          height: 0.77,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
      }
    }

    return children;
  }

  double _containerPlacementHeight(int? place) {
    switch (place) {
      case 1:
        return 85;
      case 2:
        return 60;
      case 3:
        return 45;
      default:
        return 30;
    }
  }

  Color _containerPlacementColor(int? place) {
    switch (place) {
      case 1:
        return CaboTheme.firstPlaceColor;
      case 2:
        return CaboTheme.secondPlaceColor;
      case 3:
        return CaboTheme.thirdPlaceColor;
      default:
        return Colors.blueGrey;
    }
  }
}
