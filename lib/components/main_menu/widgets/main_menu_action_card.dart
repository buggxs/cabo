import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Large action card on the main menu landing page (e.g. "Start New Board",
/// "Join a Board"): icon badge on the left, title and description on the
/// right, colored background with a bottom accent border.
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
  final Color? titleColor;
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
            border: Border(bottom: BorderSide(color: accentColor, width: 4)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: CaboTheme.cardShadow, // rgba(61,58,53,0.08)
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              if (decorationAsset != null) _buildDecoration(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildIconBadge(),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTexts(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Subtle translucent accent that bleeds out of the bottom right corner and
  // is clipped at the card edge.
  Widget _buildDecoration() {
    return Positioned(
      right: -16,
      bottom: -16,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.12,
          child: SvgPicture.asset(
            decorationAsset!,
            height: 120,
            colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CaboTheme.iconBadgeOverlay,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 32, color: foregroundColor),
    );
  }

  Widget _buildTexts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
    );
  }
}
