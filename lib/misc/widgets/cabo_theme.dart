import 'package:flutter/material.dart';

class CaboTheme {
  static const Color primaryColor = Color.fromRGBO(185, 206, 1, 1);
  static const Color primaryGreenColor = Color.fromRGBO(142, 215, 46, 1.0);
  static const Color secondaryColor = Color.fromRGBO(32, 45, 18, 1);
  static const Color tertiaryColor = Color.fromRGBO(81, 120, 30, 1);
  static const Color fourthColor = Color.fromRGBO(108, 156, 45, 1.0);

  static const Color failureRed = Color.fromRGBO(166, 0, 0, 1.0);
  static const Color failureLightRed = Color.fromRGBO(255, 84, 84, 1.0);

  static const Color firstPlaceColor = Color.fromRGBO(149, 136, 0, 1.0);
  static const Color secondPlaceColor = Color.fromRGBO(133, 133, 133, 1.0);
  static const Color thirdPlaceColor = Color.fromRGBO(128, 97, 29, 1.0);

  static const Color secondaryBackgroundColor = Color.fromRGBO(35, 49, 19, 0.9);

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

  MaterialColor toMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final int alpha = color.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };

    return MaterialColor(color.value, shades);
  }
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
