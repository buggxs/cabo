import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const route = 'about_screen';

  @override
  Widget build(BuildContext context) {
    return DarkScreenOverlay(
      child: SafeArea(
        child: Column(
          children: [
            Text(
              'About',
              style: CaboTheme.primaryTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
