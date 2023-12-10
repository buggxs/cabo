import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.text,
    this.onTap,
    this.onDoubleTap,
  }) : super(key: key);

  final String text;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  final TextStyle style = const TextStyle(
    color: Color.fromRGBO(81, 120, 30, 1.0),
    fontFamily: 'Aclonica',
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onDoubleTap: onDoubleTap,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(
              10.0,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 45, 18, 0.9),
              border: Border.all(
                color: const Color.fromRGBO(81, 120, 30, 1.0),
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Center(
              child: Text(
                text,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
