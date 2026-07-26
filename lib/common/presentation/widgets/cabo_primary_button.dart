import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Primärer Button im neuen Design mit „pressed-shadow"-Effekt:
/// Ein fester Schatten nach unten (`onPrimaryContainer`) verschwindet beim
/// Drücken, während sich der Button leicht nach unten verschiebt – das
/// vermittelt das taktile Gefühl aus `design/publish-game-screen.html`.
class CaboPrimaryButton extends StatefulWidget {
  const CaboPrimaryButton({
    required this.label,
    required this.onPressed,
    this.leading,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Optionales Widget links neben dem Label (z. B. das Google-Logo).
  final Widget? leading;

  @override
  State<CaboPrimaryButton> createState() => _CaboPrimaryButtonState();
}

class _CaboPrimaryButtonState extends State<CaboPrimaryButton> {
  bool _isPressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_enabled) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool pressed = _isPressed && _enabled;

    return Opacity(
      opacity: _enabled ? 1 : 0.5,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, pressed ? 4 : 0, 0),
          decoration: BoxDecoration(
            color: CaboTheme.primaryContainer,
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
            boxShadow: pressed
                ? const <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      color: CaboTheme.onPrimaryContainer,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.leading != null) ...<Widget>[
                widget.leading!,
                const SizedBox(width: 12),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: CaboTheme.labelLargeStyle.copyWith(
                    color: CaboTheme.onPrimaryContainer,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
