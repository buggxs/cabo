import 'package:flutter/material.dart';

class DarkScreenOverlay extends StatelessWidget {
  const DarkScreenOverlay({required this.child, this.darken, super.key});

  final Widget child;
  final double? darken;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, darken ?? 0.55)),
      child: child,
    );
  }
}
