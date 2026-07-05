import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Gemeinsamer „Bühnen"-Container für den Publish-Game-Screen.
///
/// Entspricht dem abgerundeten 4:3-Container aus
/// `design/publish-game-screen.html`. Je nach Zustand zeigt er eine
/// Icon-Illustration, einen Ladespinner oder den QR-Code.
class PublishStage extends StatelessWidget {
  const PublishStage({
    required this.child,
    this.backgroundColor = CaboTheme.surfaceContainerLow,
    super.key,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          border: Border.all(color: CaboTheme.outlineVariant),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x143D3A35),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
