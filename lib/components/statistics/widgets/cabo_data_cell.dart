import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/widgets/failure_chip.dart';
import 'package:cabo/domain/round/round.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CaboDataCell extends StatelessWidget {
  const CaboDataCell({
    super.key,
    required this.round,
    this.isLastColumn = false,
  });

  final Round round;
  final bool isLastColumn;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: isLastColumn
              ? BorderSide.none
              : const BorderSide(color: Color.fromRGBO(81, 120, 30, 1.0)),
        ),
      ),
      width: CaboTheme.cellWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                if (round.isWonRound)
                  Padding(
                    padding: EdgeInsets.only(
                      left: _isHigherPoints(round) ? 40.0 : 20.0,
                    ),
                    child: Transform(
                      transform: Matrix4.rotationZ(-100),
                      child: const Image(
                        image: AssetImage('assets/icon/winner_trophy.png'),
                        width: 20,
                      ),
                    ),
                  ),
                // Just for display purposes calculated with -5
                if (!round.hasPenaltyPoints)
                  Text(
                    '${round.hasPenaltyPoints ? round.points - 5 : round.points}',
                    style: CaboTheme.numberTextStyle.copyWith(
                      shadows: CaboTheme().textStroke(CaboTheme.secondaryColor),
                    ),
                  ),
                if (round.hasPenaltyPoints)
                  GradientText(
                    '${round.hasPenaltyPoints ? round.points - 5 : round.points}',
                    style: CaboTheme.numberTextStyle,
                    gradientType: GradientType.linear,
                    gradientDirection: GradientDirection.btt,
                    colors: const [
                      CaboTheme.failureRed,
                      CaboTheme.primaryGreenColor,
                    ],
                  ),
              ],
            ),
            const SizedBox(width: 12),
            if (round.hasPenaltyPoints) const FailureChip(chipContent: '+5'),
            if (round.hasPrecisionLanding)
              const Text(
                ' -50',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(130, 192, 54, 1.0),
                  fontFamily: 'Aclonica',
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isHigherPoints(Round round) {
    return round.points.toString().length == 2;
  }
}
