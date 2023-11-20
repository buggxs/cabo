import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class TitleCell extends StatelessWidget {
  const TitleCell({
    Key? key,
    this.titleStyle,
    required this.player,
  }) : super(key: key);

  final TextStyle? titleStyle;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(),
          bottom: BorderSide(),
        ),
      ),
      width: 115,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                player.name,
                style: titleStyle,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${player.place ?? '-'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                  Text(
                    '${player.totalPoints}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
