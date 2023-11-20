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
    color: Colors.yellow,
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
              color: const Color.fromRGBO(
                238,
                32,
                32,
                0.8,
              ),
              border: Border.all(
                color: const Color.fromRGBO(217, 206, 0, 1.0),
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
