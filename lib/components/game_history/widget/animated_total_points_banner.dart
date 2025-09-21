import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AnimatedTotalPointsBanner extends StatefulWidget {
  final int totalCollectedPoints;
  final Color backgroundColor;

  const AnimatedTotalPointsBanner({
    Key? key,
    required this.totalCollectedPoints,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedTotalPointsBannerState createState() =>
      _AnimatedTotalPointsBannerState();
}

class _AnimatedTotalPointsBannerState extends State<AnimatedTotalPointsBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.totalCollectedPoints,
    ).animate(curvedAnimation);

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedTotalPointsBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.totalCollectedPoints != oldWidget.totalCollectedPoints) {
      final CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      );
      _animation = IntTween(
        begin: 0,
        end: widget.totalCollectedPoints,
      ).animate(curvedAnimation);

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
    Widget buildStatCard({
      required String icon,
      required Widget valueWidget,
      required String label,
      required Color backgroundColor,
      EdgeInsets padding = const EdgeInsets.all(8.0),
      EdgeInsetsGeometry? margin,
    }) {
      return Card(
        color: backgroundColor,
        elevation: 5.0,
        margin: margin ?? EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                icon,
                maxLines: 1,
                style: const TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              const SizedBox(height: 4),
              valueWidget,
              const SizedBox(height: 4),
              AutoSizeText(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                minFontSize: 10,
                style: TextStyle(fontSize: 13.0, color: Colors.grey[300]),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildStatCard(
            icon: '⭐',
            valueWidget: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  '${_animation.value}',
                  style: const TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              },
            ),
            label: AppLocalizations.of(context)!.historyScreenTotalPointsTitle,
            backgroundColor: widget.backgroundColor,
            margin: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          ),
        ),
      ],
    );
  }
}
