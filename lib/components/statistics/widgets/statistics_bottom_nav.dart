import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:flutter/material.dart';

/// Untere Navigationsleiste des Spielbretts (helles Material-3-Design,
/// siehe design/game-board-screen.html). Bündelt die bestehenden Aktionen
/// "Spiel beenden" und "Online" und verlinkt zusätzlich die Regeln.
class StatisticsBottomNav extends StatelessWidget {
  const StatisticsBottomNav({
    super.key,
    required this.onEndGame,
    required this.onRules,
    required this.onOnline,
    this.isOnline = false,
  });

  final VoidCallback onEndGame;
  final VoidCallback onRules;
  final VoidCallback onOnline;

  /// Steuert die Hervorhebung des Online-Eintrags (Spiel ist veröffentlicht).
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: CaboTheme.outlineVariant)),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CaboTheme.cardRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x143D3A35), // rgba(61,58,53,0.08)
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.close,
                label: context.l10n.statsNavEndGame,
                onTap: onEndGame,
                highlighted: true,
              ),
              _NavItem(
                icon: Icons.menu_book,
                label: context.l10n.statsNavRules,
                onTap: onRules,
              ),
              _NavItem(
                icon: Icons.public,
                label: context.l10n.statsNavOnline,
                onTap: onOnline,
                foregroundColor: isOnline
                    ? CaboTheme.m3Secondary
                    : CaboTheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Hebt den Eintrag mit gefülltem Container hervor (z. B. "Spiel beenden").
  final bool highlighted;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final Color color = highlighted
        ? CaboTheme.onPrimaryContainer
        : (foregroundColor ?? CaboTheme.onSurfaceVariant);

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 2),
        Text(label, style: CaboTheme.labelSmallStyle.copyWith(color: color)),
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: Container(
        padding: highlighted
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 6)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: highlighted
            ? const BoxDecoration(
                color: CaboTheme.primaryContainer,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              )
            : null,
        child: content,
      ),
    );
  }
}
