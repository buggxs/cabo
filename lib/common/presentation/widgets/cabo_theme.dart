import 'package:cabo/domain/application/app_design.dart';
import 'package:flutter/material.dart';

/// Central theme for the app.
///
/// Colors resolve at runtime based on the active [AppDesign] (see [applyDesign]),
/// so every `CaboTheme.<color>` reference automatically follows the selected
/// design. Only colors and the background image differ between designs;
/// typography, radii and layout are shared and stay `const`.
class CaboTheme {
  static AppDesign _active = AppDesign.modern;

  static const _ModernPalette _modern = _ModernPalette();
  static const _ClassicPalette _classic = _ClassicPalette();

  static _Palette get _palette =>
      _active == AppDesign.classic ? _classic : _modern;

  /// Switches the active design. Call before rebuilding [MaterialApp] so the
  /// color getters below return the values of the selected design.
  static void applyDesign(AppDesign design) => _active = design;

  static AppDesign get activeDesign => _active;

  static bool get isClassic => _active == AppDesign.classic;

  /// Scaffold/AppBar background: transparent in the classic design so the
  /// [DesignBackground] image shows through, the normal background otherwise.
  static Color get scaffoldBackground =>
      isClassic ? Colors.transparent : background;

  // ---------------------------------------------------------------------------
  // Medaillen-Farben (Gold/Silber/Bronze) – in beiden Designs identisch.
  // ---------------------------------------------------------------------------
  static const Color firstPlaceColor = Color.fromRGBO(149, 136, 0, 1.0);
  static const Color secondPlaceColor = Color.fromRGBO(164, 164, 164, 1.0);
  static const Color thirdPlaceColor = Color.fromRGBO(128, 97, 29, 1.0);

  static const double cellWidth = 130;

  // ---------------------------------------------------------------------------
  // Farb-Token – lösen je nach aktivem Design auf.
  // ---------------------------------------------------------------------------
  static Color get background => _palette.background;
  static Color get surface => _palette.surface;
  static Color get onSurface => _palette.onSurface;
  static Color get onBackground => _palette.onBackground;

  static Color get m3Primary => _palette.m3Primary;
  static Color get onPrimary => _palette.onPrimary;
  static Color get primaryContainer => _palette.primaryContainer;
  static Color get onPrimaryContainer => _palette.onPrimaryContainer;
  static Color get primaryFixedDim => _palette.primaryFixedDim;

  static Color get m3Secondary => _palette.m3Secondary;
  static Color get onSecondary => _palette.onSecondary;
  static Color get secondaryContainer => _palette.secondaryContainer;
  static Color get onSecondaryContainer => _palette.onSecondaryContainer;
  static Color get onSecondaryFixedVariant => _palette.onSecondaryFixedVariant;

  static Color get m3Tertiary => _palette.m3Tertiary;
  static Color get onTertiary => _palette.onTertiary;
  static Color get tertiaryFixed => _palette.tertiaryFixed;

  static Color get m3Error => _palette.m3Error;
  static Color get onM3Error => _palette.onM3Error;
  static Color get errorContainer => _palette.errorContainer;
  static Color get onErrorContainer => _palette.onErrorContainer;

  static Color get outline => _palette.outline;
  static Color get outlineVariant => _palette.outlineVariant;

  static Color get surfaceVariant => _palette.surfaceVariant;
  static Color get onSurfaceVariant => _palette.onSurfaceVariant;
  static Color get surfaceContainerLowest => _palette.surfaceContainerLowest;
  static Color get surfaceContainerLow => _palette.surfaceContainerLow;
  static Color get surfaceContainer => _palette.surfaceContainer;
  static Color get surfaceContainerHigh => _palette.surfaceContainerHigh;
  static Color get surfaceContainerHighest => _palette.surfaceContainerHighest;

  static Color get inverseSurface => _palette.inverseSurface;
  static Color get inverseOnSurface => _palette.inverseOnSurface;

  /// Radius der Karten/Buttons (entspricht `xl` = 0.75rem im Design).
  static const double cardRadius = 12.0;

  // ---------------------------------------------------------------------------
  // Typografie (Rubik für Display/Headline/Body, Quicksand für Labels).
  // In beiden Designs identisch – nur die Farben wechseln.
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
    final ColorScheme colorScheme = ColorScheme(
      brightness: isClassic ? Brightness.dark : Brightness.light,
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
      appBarTheme: AppBarTheme(
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
          side: BorderSide(color: outlineVariant),
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

/// Semantic color slots shared by all designs.
abstract class _Palette {
  const _Palette();

  Color get background;
  Color get surface;
  Color get onSurface;
  Color get onBackground;

  Color get m3Primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;
  Color get primaryFixedDim;

  Color get m3Secondary;
  Color get onSecondary;
  Color get secondaryContainer;
  Color get onSecondaryContainer;
  Color get onSecondaryFixedVariant;

  Color get m3Tertiary;
  Color get onTertiary;
  Color get tertiaryFixed;

  Color get m3Error;
  Color get onM3Error;
  Color get errorContainer;
  Color get onErrorContainer;

  Color get outline;
  Color get outlineVariant;

  Color get surfaceVariant;
  Color get onSurfaceVariant;
  Color get surfaceContainerLowest;
  Color get surfaceContainerLow;
  Color get surfaceContainer;
  Color get surfaceContainerHigh;
  Color get surfaceContainerHighest;

  Color get inverseSurface;
  Color get inverseOnSurface;
}

/// Current Material 3 light design (see design/main-menu.html).
class _ModernPalette extends _Palette {
  const _ModernPalette();

  @override
  Color get background => const Color(0xFFFCF9F4);
  @override
  Color get surface => const Color(0xFFFCF9F4);
  @override
  Color get onSurface => const Color(0xFF1C1C19);
  @override
  Color get onBackground => const Color(0xFF1C1C19);

  @override
  Color get m3Primary => const Color(0xFF944A00);
  @override
  Color get onPrimary => const Color(0xFFFFFFFF);
  @override
  Color get primaryContainer => const Color(0xFFF28C38);
  @override
  Color get onPrimaryContainer => const Color(0xFF602E00);
  @override
  Color get primaryFixedDim => const Color(0xFFFFB783);

  @override
  Color get m3Secondary => const Color(0xFF216B48);
  @override
  Color get onSecondary => const Color(0xFFFFFFFF);
  @override
  Color get secondaryContainer => const Color(0xFFA9F3C7);
  @override
  Color get onSecondaryContainer => const Color(0xFF28714E);
  @override
  Color get onSecondaryFixedVariant => const Color(0xFF005233);

  @override
  Color get m3Tertiary => const Color(0xFF735C00);
  @override
  Color get onTertiary => const Color(0xFFFFFFFF);
  @override
  Color get tertiaryFixed => const Color(0xFFFFE088);

  @override
  Color get m3Error => const Color(0xFFBA1A1A);
  @override
  Color get onM3Error => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFFFFDAD6);
  @override
  Color get onErrorContainer => const Color(0xFF93000A);

  @override
  Color get outline => const Color(0xFF887365);
  @override
  Color get outlineVariant => const Color(0xFFDBC2B2);

  @override
  Color get surfaceVariant => const Color(0xFFE5E2DD);
  @override
  Color get onSurfaceVariant => const Color(0xFF554337);
  @override
  Color get surfaceContainerLowest => const Color(0xFFFFFFFF);
  @override
  Color get surfaceContainerLow => const Color(0xFFF6F3EE);
  @override
  Color get surfaceContainer => const Color(0xFFF0EDE9);
  @override
  Color get surfaceContainerHigh => const Color(0xFFEBE8E3);
  @override
  Color get surfaceContainerHighest => const Color(0xFFE5E2DD);

  @override
  Color get inverseSurface => const Color(0xFF31302D);
  @override
  Color get inverseOnSurface => const Color(0xFFF3F0EB);
}

/// Classic design: original dark-green look with lime accents. Old palette
/// colors are mapped onto the semantic slots; the darker green surface shades
/// are derived from #202D12/#233113 and may be fine-tuned during visual QA.
class _ClassicPalette extends _Palette {
  const _ClassicPalette();

  static const Color _lime = Color(0xFFB9CE01); // primaryColor
  static const Color _limeLight = Color(0xFFB1DA00); // primaryColorLight
  static const Color _green = Color(0xFF8ED72E); // primaryGreenColor
  static const Color _darkGreen = Color(0xFF202D12); // secondaryColor
  static const Color _midGreen = Color(0xFF51781E); // tertiaryColor
  static const Color _lightGreen = Color(0xFF6C9C2D); // fourthColor

  @override
  Color get background => _darkGreen;
  @override
  Color get surface => const Color(0xFF233113); // secondaryBackgroundColor
  @override
  Color get onSurface => _lime;
  @override
  Color get onBackground => _lime;

  @override
  Color get m3Primary => _lime;
  @override
  Color get onPrimary => _darkGreen;
  @override
  Color get primaryContainer => _midGreen;
  @override
  Color get onPrimaryContainer => _limeLight;
  @override
  Color get primaryFixedDim => _green;

  @override
  Color get m3Secondary => _green;
  @override
  Color get onSecondary => _darkGreen;
  @override
  Color get secondaryContainer => _midGreen;
  @override
  Color get onSecondaryContainer => _limeLight;
  @override
  Color get onSecondaryFixedVariant => _limeLight;

  @override
  Color get m3Tertiary => _limeLight;
  @override
  Color get onTertiary => _darkGreen;
  @override
  Color get tertiaryFixed => _lightGreen;

  @override
  Color get m3Error => const Color(0xFFA60000); // failureRed
  @override
  Color get onM3Error => const Color(0xFFFFFFFF);
  @override
  Color get errorContainer => const Color(0xFF4A1010);
  @override
  Color get onErrorContainer => const Color(0xFFFF5454); // failureLightRed

  @override
  Color get outline => _midGreen;
  @override
  Color get outlineVariant => _lightGreen;

  @override
  Color get surfaceVariant => const Color(0xFF2C3D18);
  @override
  Color get onSurfaceVariant => _limeLight;
  @override
  Color get surfaceContainerLowest => const Color(0xFF1A2410);
  @override
  Color get surfaceContainerLow => _darkGreen;
  @override
  Color get surfaceContainer => const Color(0xFF233113);
  @override
  Color get surfaceContainerHigh => const Color(0xFF2C3D18);
  @override
  Color get surfaceContainerHighest => const Color(0xFF35491A);

  @override
  Color get inverseSurface => const Color(0xFFFCF9F4);
  @override
  Color get inverseOnSurface => _darkGreen;
}
