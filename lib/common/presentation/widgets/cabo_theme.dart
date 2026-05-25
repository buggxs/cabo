import 'package:flutter/material.dart';

class CaboTheme {
  // ---------------------------------------------------------------------------
  // Legacy-Palette (dunkles Theme) — bleibt erhalten, bis die übrigen Screens
  // ebenfalls auf das neue Material-3-Design umgestellt sind.
  // ---------------------------------------------------------------------------
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

  // ---------------------------------------------------------------------------
  // Neue Material-3-Light-Palette (siehe design/main-menu.html).
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFFFCF9F4);
  static const Color surface = Color(0xFFFCF9F4);
  static const Color onSurface = Color(0xFF1C1C19);
  static const Color onBackground = Color(0xFF1C1C19);

  static const Color m3Primary = Color(0xFF944A00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFF28C38);
  static const Color onPrimaryContainer = Color(0xFF602E00);

  static const Color m3Secondary = Color(0xFF216B48);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFA9F3C7);
  static const Color onSecondaryContainer = Color(0xFF28714E);
  static const Color onSecondaryFixedVariant = Color(0xFF005233);

  static const Color m3Tertiary = Color(0xFF735C00);
  static const Color onTertiary = Color(0xFFFFFFFF);

  static const Color m3Error = Color(0xFFBA1A1A);
  static const Color onM3Error = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color outline = Color(0xFF887365);
  static const Color outlineVariant = Color(0xFFDBC2B2);

  static const Color surfaceVariant = Color(0xFFE5E2DD);
  static const Color onSurfaceVariant = Color(0xFF554337);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainer = Color(0xFFF0EDE9);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);

  static const Color inverseSurface = Color(0xFF31302D);
  static const Color inverseOnSurface = Color(0xFFF3F0EB);

  /// Radius der neuen Karten/Buttons (entspricht `xl` = 0.75rem im Design).
  static const double cardRadius = 12.0;

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

  // ---------------------------------------------------------------------------
  // Neue Typografie (Rubik für Display/Headline/Body, Quicksand für Labels).
  // Skala entspricht design/main-menu.html.
  // ---------------------------------------------------------------------------
  static const TextStyle displayLargeStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 40,
    height: 48 / 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8, // ~ -0.02em
  );

  static const TextStyle headlineLargeStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headlineMediumStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLargeStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMediumStyle = TextStyle(
    fontFamily: 'Rubik',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelLargeStyle = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.28, // ~ 0.02em
  );

  static const TextStyle labelSmallStyle = TextStyle(
    fontFamily: 'Quicksand',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static ThemeData get themeData {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: m3Primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: m3Secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: m3Tertiary,
      onTertiary: onTertiary,
      error: m3Error,
      onError: onM3Error,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      primaryColor: m3Primary,
      scaffoldBackgroundColor: surface,
      fontFamily: 'Rubik',
      colorScheme: colorScheme,
      textTheme: const TextTheme(
        displayLarge: displayLargeStyle,
        headlineLarge: headlineLargeStyle,
        headlineMedium: headlineMediumStyle,
        bodyLarge: bodyLargeStyle,
        bodyMedium: bodyMediumStyle,
        labelLarge: labelLargeStyle,
        labelSmall: labelSmallStyle,
      ).apply(bodyColor: onSurface, displayColor: onSurface),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: onSurface,
        iconTheme: IconThemeData(color: onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: onPrimary,
          backgroundColor: m3Primary,
          textStyle: labelLargeStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: m3Primary,
          side: const BorderSide(color: outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: m3Primary),
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
