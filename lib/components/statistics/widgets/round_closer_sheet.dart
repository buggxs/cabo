import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Bottom sheet to pick the player who closed the round
/// (see design/round-finished.html). Tapping a player immediately returns
/// the selected [Player] via `Navigator.pop`; cancel/dismiss returns `null`.
class RoundCloserSheet extends StatelessWidget {
  const RoundCloserSheet({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CaboTheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x263D3A35), // rgba(61,58,53,0.15)
            blurRadius: 24,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: CaboTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.dialogRoundFinishedTitle,
                style: CaboTheme.headlineMediumStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CaboTheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.dialogTextRoundFinishedBy,
                style: CaboTheme.bodyMediumStyle.copyWith(
                  color: CaboTheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final Player player in players)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PlayerOption(
                            player: player,
                            onTap: () => Navigator.of(context).pop(player),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _FooterButton(
                label: context.l10n.dialogCancel,
                backgroundColor: CaboTheme.surfaceContainerLow,
                foregroundColor: CaboTheme.onSurfaceVariant,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerOption extends StatelessWidget {
  const _PlayerOption({required this.player, required this.onTap});

  final Player player;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(CaboTheme.cardRadius);

    return Material(
      color: CaboTheme.surfaceContainerHigh,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: CaboTheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: CaboTheme.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: CaboTheme.onSurface),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  player.name,
                  style: CaboTheme.headlineMediumStyle.copyWith(
                    color: CaboTheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.chevron_right, color: CaboTheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            label,
            style: CaboTheme.labelLargeStyle.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
