import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
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
      width: CaboTheme.cellWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  style: titleStyle?.copyWith(
                    color: CaboTheme.fourthColor,
                    shadows: const [
                      Shadow(
                        // bottomLeft
                        offset: Offset(-0.5, -0.5),
                        color: CaboTheme.secondaryColor,
                      ),
                      Shadow(
                        // bottomRight
                        offset: Offset(01.5, -0.5),
                        color: CaboTheme.secondaryColor,
                      ),
                      Shadow(
                        // topRight
                        offset: Offset(0.5, 0.5),
                        color: CaboTheme.secondaryColor,
                      ),
                      Shadow(
                        // topLeft
                        offset: Offset(-0.5, 0.5),
                        color: CaboTheme.secondaryColor,
                      ),
                    ],
                  ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Aclonica',
                      color: _getPlacementColor(player.place),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: CaboTheme.primaryGreenColor,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${player.totalPoints}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Aclonica',
                          color: CaboTheme.primaryGreenColor,
                        ),
                      ),
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

  Color _getPlacementColor(int? place) {
    switch (place) {
      case 1:
        return CaboTheme.firstPlaceColor;
      case 2:
        return CaboTheme.secondPlaceColor;
      case 3:
        return CaboTheme.thirdPlaceColor;
      default:
        return CaboTheme.tertiaryColor;
    }
  }
}
