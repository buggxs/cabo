import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Branding-Kopf der Hauptmenü-Landing: Logo, Titel "CABO Board" und Untertitel.
class MainMenuHeader extends StatelessWidget {
  const MainMenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/cabo_card_icon.svg',
          height: 48,
          colorFilter: ColorFilter.mode(
            CaboTheme.m3Primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${context.l10n.gameName} ${context.l10n.gameSubTitle}',
          textAlign: TextAlign.center,
          style: context.textTheme.displayLarge?.copyWith(
            color: CaboTheme.m3Primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.mainMenuSubtitle,
          textAlign: TextAlign.center,
          style: context.textTheme.labelLarge?.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
