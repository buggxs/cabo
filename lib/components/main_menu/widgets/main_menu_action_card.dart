import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Große Aktions-Karte der Hauptmenü-Landing (z. B. "Start New Board",
/// "Join a Board"): Icon-Badge links, Titel + Beschreibung rechts, farbiger
/// Hintergrund mit unterer Akzent-Border.
class MainMenuActionCard extends StatelessWidget {
  const MainMenuActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.accentColor,
    required this.onTap,
    this.titleColor,
    this.decorationAsset,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color accentColor;

  /// Optionale, abweichende Farbe für den Titel (Standard: [foregroundColor]).
  final Color? titleColor;

  /// Optionales dekoratives SVG, das als dezenter, durchscheinender Akzent
  /// unten rechts in die Karte ragt (am Kartenrand abgeschnitten).
  final String? decorationAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
            border: Border(
              bottom: BorderSide(color: accentColor, width: 4),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x143D3A35), // rgba(61,58,53,0.08)
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              if (decorationAsset != null)
                Positioned(
                  right: -16,
                  bottom: -16,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.12,
                      child: SvgPicture.asset(
                        decorationAsset!,
                        height: 120,
                        colorFilter: ColorFilter.mode(
                          foregroundColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: foregroundColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: titleColor ?? foregroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: foregroundColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
