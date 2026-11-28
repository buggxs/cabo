import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

/// Primary button with a "pressed shadow" effect: a solid shadow below
/// (`onPrimaryContainer`) disappears while pressed and the button shifts down
/// slightly, giving the tactile feel of `design/publish-game-screen.html`.
class CaboPrimaryButton extends StatefulWidget {
  const CaboPrimaryButton({
    required this.label,
    required this.onPressed,
    this.leading,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  final Widget? leading;

  @override
  State<CaboPrimaryButton> createState() => _CaboPrimaryButtonState();
}

class _CaboPrimaryButtonState extends State<CaboPrimaryButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null;

  void _setPressed(bool isPressed) {
    if (!_isEnabled) return;
    setState(() => _isPressed = isPressed);
  }

  @override
  Widget build(BuildContext context) {
    final bool isShownPressed = _isPressed && _isEnabled;

    return Opacity(
      opacity: _isEnabled ? 1 : 0.5,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, isShownPressed ? 4 : 0, 0),
          decoration: BoxDecoration(
            color: CaboTheme.primaryContainer,
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
            boxShadow: isShownPressed
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
