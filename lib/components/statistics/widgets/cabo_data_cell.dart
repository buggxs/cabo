import 'package:cabo/components/statistics/widgets/failure_chip.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class CaboDataCell extends StatelessWidget {
  const CaboDataCell({
    Key? key,
    required this.round,
    this.isLastColumn = false,
  }) : super(key: key);

  final Round round;
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
        ),
      ),
      width: CaboTheme.cellWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              if (round.isWonRound)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Transform(
                    transform: Matrix4.rotationZ(
                      -100,
                    ),
                    child: const Image(
                      image: AssetImage('assets/icon/winner_trophy.png'),
                      width: 20,
                    ),
                  ),
                ),
              // Just for display purposes calculated with -5
              Text(
                '${round.hasPenaltyPoints ? round.points - 5 : round.points}',
                style: CaboTheme.numberTextStyle.copyWith(
                  // https://pub.dev/packages/simple_gradient_text
                  shadows: const [
                    Shadow(
                      // bottomLeft
                      offset: Offset(-1.5, -1.5),
                      color: CaboTheme.secondaryColor,
                    ),
                    Shadow(
                      // bottomRight
                      offset: Offset(1.5, -1.5),
                      color: CaboTheme.secondaryColor,
                    ),
                    Shadow(
                      // topRight
                      offset: Offset(1.5, 1.5),
                      color: CaboTheme.secondaryColor,
                    ),
                    Shadow(
                      // topLeft
                      offset: Offset(-1.5, 1.5),
                      color: CaboTheme.secondaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          if (round.hasPenaltyPoints) const FailureChip(chipContent: '+5'),
          if (round.hasPrecisionLanding)
            const Text(
              '-50',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(130, 192, 54, 1.0),
                fontFamily: 'Aclonica',
              ),
            ),
        ],
      ),
    );
  }
}
