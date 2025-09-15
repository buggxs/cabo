import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:flutter/material.dart';

class CaboDefaultView extends StatelessWidget {
  const CaboDefaultView({
    required this.child,
    this.useOverlay = false,
    this.appBar,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool useOverlay;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: useOverlay
            ? DarkScreenOverlay(darken: 0.70, child: SafeArea(child: child))
            : SafeArea(child: child),
      ),
    );
  }
}
