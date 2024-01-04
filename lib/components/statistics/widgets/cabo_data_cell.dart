import 'package:cabo/domain/round/round.dart';
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
      width: 115,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Just for display purposes calculated with -5
          Text(
            '${round.hasPenaltyPoints ? round.points - 5 : round.points}',
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Aclonica',
              color: Color.fromRGBO(130, 192, 54, 1.0),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          if (round.hasPenaltyPoints)
            const Text(
              '+5',
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
                fontFamily: 'Aclonica',
              ),
            ),
        ],
      ),
    );
  }
}
