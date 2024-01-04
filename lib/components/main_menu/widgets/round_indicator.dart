import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  const RoundIndicator({
    Key? key,
    required this.round,
  }) : super(key: key);

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
