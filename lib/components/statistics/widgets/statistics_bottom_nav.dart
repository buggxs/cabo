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
      decoration: BoxDecoration(
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
                icon: Icons.logout,
                label: context.l10n.statsNavEndGame,
                onTap: onEndGame,
              ),
              _NavItem(
                icon: Icons.menu_book,
                label: context.l10n.statsNavRules,
                onTap: onRules,
              ),
              _NavItem(
                icon: Icons.public,
                label: isOnline
                    ? context.l10n.statsNavOnline
                    : context.l10n.statsNavShare,
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
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final Color color = foregroundColor ?? CaboTheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: CaboTheme.labelSmallStyle.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
