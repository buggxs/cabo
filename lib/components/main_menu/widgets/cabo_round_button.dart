import 'package:flutter/material.dart';

class CaboRoundButton extends StatelessWidget {
  const CaboRoundButton({
    Key? key,
    required this.changePlayerAmount,
    this.icon = const Icon(
      Icons.add,
      color: Colors.green,
      size: 30,
    ),
  }) : super(key: key);

  final void Function() changePlayerAmount;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changePlayerAmount,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromRGBO(32, 45, 18, 1.0),
          border: Border.all(
            color: const Color.fromRGBO(81, 120, 30, 1.0),
            width: 2,
          ),
        ),
        child: icon,
      ),
    );
  }
}
