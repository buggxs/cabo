import 'package:flutter/material.dart';

class DarkScreenOverlay extends StatelessWidget {
  const DarkScreenOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.55),
      ),
      child: child,
    );
  }
}
