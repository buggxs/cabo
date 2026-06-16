import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:flutter/material.dart';

/// Grünes Hero-Banner im neuen Material-3-Design, das die über alle Spiele
/// gesammelten Punkte animiert hochzählt (vgl. Design).
class AnimatedTotalPointsBanner extends StatefulWidget {
  const AnimatedTotalPointsBanner({
    super.key,
    required this.totalCollectedPoints,
  });

  final int totalCollectedPoints;

  @override
  State<AnimatedTotalPointsBanner> createState() =>
      _AnimatedTotalPointsBannerState();
}

class _AnimatedTotalPointsBannerState extends State<AnimatedTotalPointsBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.totalCollectedPoints,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedTotalPointsBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalCollectedPoints != oldWidget.totalCollectedPoints) {
      _animation = IntTween(
        begin: 0,
        end: widget.totalCollectedPoints,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CaboTheme.secondaryContainer,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        ),
        child: Stack(
          children: <Widget>[
            // Großer, transparenter Deko-Stern oben rechts.
            Positioned(
              top: -24,
              right: -16,
              child: Icon(
                Icons.star_rounded,
                size: 140,
                color: CaboTheme.m3Secondary.withValues(alpha: 0.12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.star_rounded,
                    size: 28,
                    color: CaboTheme.onSecondaryFixedVariant,
                  ),
                  const SizedBox(height: 4),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                      return Text(
                        '${_animation.value}',
                        style: CaboTheme.displayLargeStyle.copyWith(
                          color: CaboTheme.onSecondaryFixedVariant,
                          fontSize: 52,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.historyScreenTotalPointsTitle.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: CaboTheme.labelLargeStyle.copyWith(
                      color: CaboTheme.m3Secondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
