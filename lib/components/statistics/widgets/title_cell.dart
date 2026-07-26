import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:flutter/material.dart';

class TitleCell extends StatelessWidget {
  const TitleCell({super.key, required this.player, this.isLastColumn = false});

  final Player player;
  final bool isLastColumn;

  @override
  Widget build(BuildContext context) {
    // Führender Spieler (Platz 1) wird grün hervorgehoben (siehe Design).
    final bool isLeading = player.place == 1;
    final Color nameColor = isLeading
        ? CaboTheme.m3Secondary
        : CaboTheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerHigh,
        border: Border(
          right: isLastColumn
              ? BorderSide.none
              : BorderSide(color: CaboTheme.outlineVariant),
          bottom: BorderSide(color: CaboTheme.outlineVariant),
        ),
      ),
      width: CaboTheme.cellWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AutoSizeText(
                    player.name,
                    textAlign: TextAlign.center,
                    style: CaboTheme.labelLargeStyle.copyWith(
                      fontSize: 16,
                      color: nameColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLeading) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.style,
                    size: 16,
                    color: CaboTheme.m3Secondary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                '#${player.place ?? '-'}',
                style: CaboTheme.labelLargeStyle.copyWith(
                  fontSize: 20,
                  color: _getPlacementColor(player.place),
                ),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: CaboTheme.m3Primary),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AutoSizeText(
                    '${player.totalPoints}',
                    style: CaboTheme.headlineMediumStyle.copyWith(
                      fontSize: 18,
                      color: CaboTheme.m3Primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPlacementColor(int? place) {
    switch (place) {
      case 1:
        return CaboTheme.firstPlaceColor;
      case 2:
        return CaboTheme.secondPlaceColor;
      case 3:
        return CaboTheme.thirdPlaceColor;
      default:
        return CaboTheme.onSurfaceVariant;
    }
  }
}
