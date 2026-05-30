import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

/// Bottom-Sheet zur Auswahl des Spielers, der die Runde geschlossen hat
/// (siehe design/round-finished.html). Liefert den ausgewählten [Player]
/// via `Navigator.pop`, oder `null` bei Abbruch/Wegwischen.
class RoundCloserSheet extends StatefulWidget {
  const RoundCloserSheet({super.key, required this.players});

  final List<Player> players;

  @override
  State<RoundCloserSheet> createState() => _RoundCloserSheetState();
}

class _RoundCloserSheetState extends State<RoundCloserSheet> {
  Player? _selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CaboTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
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
              // Drag-Handle
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
                      for (final Player player in widget.players)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _PlayerOption(
                            player: player,
                            selected: _selected == player,
                            onTap: () => setState(() => _selected = player),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _FooterButton(
                      label: context.l10n.dialogCancel,
                      backgroundColor: CaboTheme.surfaceContainerLow,
                      foregroundColor: CaboTheme.onSurfaceVariant,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _FooterButton(
                      label: context.l10n.dialogEnterPoints,
                      backgroundColor: CaboTheme.m3Secondary,
                      foregroundColor: CaboTheme.onSecondary,
                      shadowColor: CaboTheme.onSecondaryFixedVariant,
                      onTap: _selected == null
                          ? null
                          : () => Navigator.of(context).pop(_selected),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerOption extends StatelessWidget {
  const _PlayerOption({
    required this.player,
    required this.selected,
    required this.onTap,
  });

  final Player player;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = selected
        ? CaboTheme.primaryContainer
        : CaboTheme.surfaceContainerHigh;
    final Color foreground = selected
        ? CaboTheme.onPrimaryContainer
        : CaboTheme.onSurface;
    final BorderRadius radius = BorderRadius.circular(CaboTheme.cardRadius);

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: CaboTheme.onPrimaryContainer,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: background,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: selected
                  ? null
                  : Border.all(color: CaboTheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? CaboTheme.onPrimaryContainer.withValues(alpha: 0.2)
                        : CaboTheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, color: foreground),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    player.name,
                    style: CaboTheme.headlineMediumStyle.copyWith(
                      color: foreground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selected) Icon(Icons.check_circle, color: foreground),
              ],
            ),
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
    this.shadowColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? shadowColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null;
    final BorderRadius radius = BorderRadius.circular(CaboTheme.cardRadius);

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: (shadowColor != null && !disabled)
              ? [BoxShadow(color: shadowColor!, offset: const Offset(0, 4))]
              : null,
        ),
        child: Material(
          color: backgroundColor,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Text(
                label,
                style: CaboTheme.labelLargeStyle.copyWith(
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
