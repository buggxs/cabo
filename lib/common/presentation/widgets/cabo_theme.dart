import 'package:flutter/material.dart';

class CaboTheme {
  static const Color primaryColor = Color.fromRGBO(185, 206, 1, 1);
  static const Color primaryColorLight = Color.fromRGBO(177, 218, 0, 1.0);
  static const Color primaryGreenColor = Color.fromRGBO(142, 215, 46, 1.0);
  static const Color secondaryColor = Color.fromRGBO(32, 45, 18, 1);
  static const Color tertiaryColor = Color.fromRGBO(81, 120, 30, 1);
  static const Color fourthColor = Color.fromRGBO(108, 156, 45, 1.0);
  static const Color secondaryBackgroundColor = Color.fromRGBO(35, 49, 19, 0.9);

  static const Color failureRed = Color.fromRGBO(166, 0, 0, 1.0);
  static const Color failureLightRed = Color.fromRGBO(255, 84, 84, 1.0);

  static const Color firstPlaceColor = Color.fromRGBO(149, 136, 0, 1.0);
  static const Color secondPlaceColor = Color.fromRGBO(164, 164, 164, 1.0);
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

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      fontFamily: 'Archivo',
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primaryColor,
        onPrimary: secondaryColor, // Text auf primären Buttons
        secondary: tertiaryColor,
        onSecondary: primaryColor,
        error: failureRed,
        onError: primaryColor,
        surface: secondaryBackgroundColor,
        onSurface: primaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: primaryTextStyle,
        headlineLarge: primaryTextStyle,
        headlineMedium: primaryTextStyle.copyWith(fontSize: 20),
        titleLarge: primaryTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: secondaryTextStyle,
        bodyMedium: secondaryTextStyle.copyWith(fontSize: 16),
        bodySmall: secondaryTextStyle.copyWith(fontSize: 14),
        labelLarge: primaryTextStyle,
      ).apply(bodyColor: primaryColor, displayColor: primaryColor),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: primaryTextStyle.copyWith(fontSize: 38),
        iconTheme: const IconThemeData(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: secondaryColor,
          textStyle: secondaryTextStyle.copyWith(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: primaryColor),
      ),
    );
  }
}

extension ColorToMaterialConverter on Color {
  MaterialColor get toMaterialColor {
    final int red = r.toInt();
    final int green = g.toInt();
    final int blue = b.toInt();

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

    return MaterialColor(toARGB32(), shades);
  }
}
