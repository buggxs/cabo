import 'package:cabo/domain/round/round.dart';
import 'package:flutter/material.dart';

class CaboDataCell extends StatelessWidget {
  const CaboDataCell({
    Key? key,
    required this.round,
  }) : super(key: key);

  final Round round;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(),
        ),
      ),
      width: 115,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${round.points}',
            style: const TextStyle(fontSize: 18),
          ),
          if (round.hasPenaltyPoints)
            const Text(
              '+5',
              style: TextStyle(
                fontSize: 18,
                color: Colors.redAccent,
              ),
            ),
        ],
      ),
    );
  }
}
