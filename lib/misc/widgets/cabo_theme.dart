import 'package:flutter/material.dart';

class CaboTheme {
  static const Color primaryColor = Color.fromRGBO(185, 206, 1, 1);
  static const Color primaryGreenColor = Color.fromRGBO(142, 215, 46, 1.0);
  static const Color secondaryColor = Color.fromRGBO(32, 45, 18, 1);
  static const Color tertiaryColor = Color.fromRGBO(81, 120, 30, 1);
  static const Color fourthColor = Color.fromRGBO(108, 156, 45, 1.0);
  static const Color secondaryBackgroundColor = Color.fromRGBO(35, 49, 19, 0.9);

  static const Color failureRed = Color.fromRGBO(166, 0, 0, 1.0);
  static const Color failureLightRed = Color.fromRGBO(255, 84, 84, 1.0);

  static const Color firstPlaceColor = Color.fromRGBO(149, 136, 0, 1.0);
  static const Color secondPlaceColor = Color.fromRGBO(133, 133, 133, 1.0);
  static const Color thirdPlaceColor = Color.fromRGBO(128, 97, 29, 1.0);

  static const double cellWidth = 130;

  static const TextStyle primaryTextStyle = TextStyle(
    fontFamily: 'Archivo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle secondaryTextStyle = TextStyle(
    fontFamily: 'Archivo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );

  static const TextStyle numberTextStyle = TextStyle(
    fontSize: 25,
    color: primaryGreenColor,
    fontFamily: 'Aclonica',
  );

  List<Shadow> textStroke(Color color) => [
        Shadow(
          // bottomLeft
          offset: const Offset(-1.5, -1.5),
          color: color,
        ),
        Shadow(
          // bottomRight
          offset: const Offset(1.5, -1.5),
          color: color,
        ),
        Shadow(
          // topRight
          offset: const Offset(1.5, 1.5),
          color: color,
        ),
        Shadow(
          // topLeft
          offset: const Offset(-1.5, 1.5),
          color: color,
        ),
      ];
}

extension ColorToMaterialConverter on Color {
  MaterialColor get toMaterialColor {
    final int red = this.red;
    final int green = this.green;
    final int blue = this.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(value, shades);
  }
}
