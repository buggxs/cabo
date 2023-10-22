import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';

class StrokeText extends Text {
  const StrokeText(
    this.text, {
    Key? key,
    this.isTextItem = false,
    this.fontSize,
    this.color,
    this.strokeColor,
  }) : super(key: key, text);

  final String text;
  final double? fontSize;
  final Color? color;
  final Color? strokeColor;
  final bool isTextItem;

  @override
  Widget build(BuildContext context) => _createStrokeTextWidget;

  Text get _createStrokeTextWidget => Text(
        text,
        style: TextStyle(
          inherit: true,
          fontSize: fontSize ?? 48.0,
          fontWeight: FontWeight.w900,
          color: color ?? Colors.black,
          shadows: [
            Shadow(
              // bottomLeft
              offset: const Offset(-3.5, -3.5),
              color: strokeColor ?? Colors.white,
            ),
            Shadow(
              // bottomRight
              offset: const Offset(3.5, -3.5),
              color: strokeColor ?? Colors.white,
            ),
            Shadow(
              // topRight
              offset: const Offset(3.5, 3.5),
              color: strokeColor ?? Colors.white,
            ),
            Shadow(
              // topLeft
              offset: const Offset(-3.5, 3.5),
              color: strokeColor ?? Colors.white,
            ),
          ],
        ),
      );

  TextItem get asTextItem =>
      TextItem(text: _createStrokeTextWidget, startAngle: 250, space: 12.0);
}
