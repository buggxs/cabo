import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/game/game_streak.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:cabo/misc/utils/date_parser.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Helper function to darken a color
// amount should be between 0.0 and 1.0
Color darkenColor(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

// Helper function to lighten a color
// amount should be between 0.0 and 1.0
Color lightenColor(Color color, [double amount = 0.1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  return hslLight.toColor();
}

class GameCard extends StatelessWidget {
  const GameCard({Key? key, required this.game}) : super(key: key);

  final Game game;

  @override
  Widget build(BuildContext context) {
    final List<Player> sortedPlayers = List<Player>.from(game.players)
      ..sort((a, b) => (a.place ?? 99).compareTo(b.place ?? 99));

    final bool isWinningStreak = game.getGameStreaks().isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias, // Ensures content respects border radius
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Use the helper function
              darkenColor(CaboTheme.secondaryBackgroundColor, 0.05),
              // Use the helper function
              lightenColor(CaboTheme.secondaryBackgroundColor, 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isWinningStreak),
              const SizedBox(height: 16.0),
              _buildPlayerList(context, sortedPlayers),
              const SizedBox(height: 8.0), // Add some space at the bottom
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isWinningStreak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              DateFormat('dd MMM yyyy').format(
                DateFormat().parseCaboDateString(game.startedAt!) ??
                    DateTime.now(),
              ), // More readable format
              style: CaboTheme.secondaryTextStyle.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        if (isWinningStreak)
          Builder(
            builder: (context) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3), // Subtle border color
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ), // Rounded corners for the border
                  color: Colors.black.withOpacity(
                    0.15,
                  ), // Slight background tint
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Take minimum space
                  children: [
                    Text(
                      AppLocalizations.of(context)!.streakTitle, // Label
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ), // Space between label and icon(s)
                    // Row for icons if multiple streaks/badges exist
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isWinningStreak)
                          ...game
                              .getGameStreaks()
                              .map(
                                (GameStreak streak) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3.0,
                                  ),
                                  child: Tooltip(
                                    message: streak.message,
                                    triggerMode: TooltipTriggerMode.tap,
                                    child: streak.icon,
                                  ),
                                ),
                              )
                              .toList(),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPlayerList(BuildContext context, List<Player> players) {
    return Column(
      children: players
          .map((player) => _buildPlayerRow(context, player))
          .toList(),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align duration to the end
      children: [
        Icon(
          Icons.timer_outlined,
          color: Colors.white.withOpacity(0.6), // More subtle icon color
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          game.gameDuration,
          style: CaboTheme.secondaryTextStyle.copyWith(
            color: Colors.white.withOpacity(0.8), // More subtle text color
            fontSize: 12, // Smaller font size
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerRow(BuildContext context, Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          _buildPlaceIndicator(player.place),
          const SizedBox(width: 12),
          Expanded(
            child: AutoSizeText(
              player.name,
              maxLines: 1,
              minFontSize: 12,
              style: CaboTheme.secondaryTextStyle.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${player.totalPoints}',
            style: CaboTheme.numberTextStyle.copyWith(
              // Use the helper function
              color: lightenColor(_getPlaceColor(player.place), 0.1),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceIndicator(int? place) {
    final Color color = _getPlaceColor(place);
    final IconData? icon = _getPlaceIcon(place);

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        // Use the helper function
        border: Border.all(color: lightenColor(color, 0.2), width: 1.5),
      ),
      child: Center(
        child: icon != null
            ? Icon(icon, color: Colors.white, size: 18)
            : Text(
                place?.toString() ?? '-',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }

  Color _getPlaceColor(int? place) {
    switch (place) {
      case 1:
        return CaboTheme.firstPlaceColor; // Gold-ish
      case 2:
        return CaboTheme.secondPlaceColor; // Silver-ish
      case 3:
        return CaboTheme.thirdPlaceColor; // Bronze-ish
      default:
        return Colors.blueGrey.shade600;
    }
  }

  IconData? _getPlaceIcon(int? place) {
    switch (place) {
      case 1:
        return Icons.emoji_events; // Trophy icon
      // case 2: return Icons.military_tech; // Could use different icons
      // case 3: return Icons.star_border;
      default:
        return null; // Show number for other places
    }
  }
}
