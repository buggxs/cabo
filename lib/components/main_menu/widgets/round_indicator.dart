import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  const RoundIndicator({super.key, required this.round});

  final int round;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      child: Text(
        '$round.)',
        style: const TextStyle(
          fontSize: 10,
          fontFamily: 'Aclonica',
          color: Color.fromRGBO(81, 120, 30, 1),
        ),
      ),
    );
  }
}
