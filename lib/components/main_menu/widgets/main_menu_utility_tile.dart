import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Kompakte Kachel im 3er-Grid der Hauptmenü-Landing (z. B. Regeln, Historie,
/// Über die App): Icon oben, Label in Großbuchstaben darunter.
class MainMenuUtilityTile extends StatelessWidget {
  const MainMenuUtilityTile({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CaboTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
            border: Border.all(color: CaboTheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: CaboTheme.m3Secondary),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: CaboTheme.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
