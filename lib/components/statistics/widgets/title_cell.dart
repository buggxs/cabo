import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class TitleCell extends StatelessWidget {
  const TitleCell({
    Key? key,
    this.titleStyle,
    required this.player,
    this.isLastColumn = false,
  }) : super(key: key);

  final TextStyle? titleStyle;
  final Player player;
  final bool isLastColumn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: isLastColumn
              ? BorderSide.none
              : const BorderSide(
                  color: Color.fromRGBO(81, 120, 30, 1.0),
                ),
          bottom: const BorderSide(
            color: Color.fromRGBO(81, 120, 30, 1.0),
          ),
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
              SizedBox(
                height: 30,
                child: AutoSizeText(
                  player.name,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
                      color: Color.fromRGBO(81, 120, 30, 1),
                    ),
                  ),
                  Text(
                    '${player.totalPoints}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Aclonica',
                      color: Color.fromRGBO(130, 192, 54, 1),
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
