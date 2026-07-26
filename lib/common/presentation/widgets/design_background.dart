import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Wraps [child] with the classic full-screen background image when the classic
/// design is active. For the modern design it returns [child] unchanged.
///
/// Wrap a screen's [Scaffold] body with this and keep the scaffold background
/// transparent so the image shows through.
class DesignBackground extends StatelessWidget {
  const DesignBackground({super.key, required this.child, this.darken = 0.55});

  static const String _backgroundAsset =
      'assets/images/cabo-main-menu-background.png';

  /// Opacity of the dark scrim placed over the image so text stays readable.
  final double darken;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!CaboTheme.isClassic) {
      return child;
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_backgroundAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: ColoredBox(
        color: Color.fromRGBO(0, 0, 0, darken),
        child: child,
      ),
    );
  }
}
