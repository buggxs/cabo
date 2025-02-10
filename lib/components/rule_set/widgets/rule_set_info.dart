import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class RuleInfo extends StatefulWidget {
  const RuleInfo({
    super.key,
    required this.info,
  });

  final String info;

  @override
  State<RuleInfo> createState() => _RuleInfoState();
}

class _RuleInfoState extends State<RuleInfo> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isVisible = false;

  void _showInfo() {
    if (!mounted) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideInfo,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: 200,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(-160, 40),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CaboTheme.secondaryColor,
                    border: Border.all(color: CaboTheme.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.info,
                    style: CaboTheme.secondaryTextStyle.copyWith(
                      color: CaboTheme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
  }

  void _hideInfo() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  @override
  void dispose() {
    _hideInfo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: const Icon(
          Icons.help_outline,
          color: CaboTheme.primaryColor,
          size: 20,
        ),
        onPressed: () {
          if (_isVisible) {
            _hideInfo();
          } else {
            _showInfo();
          }
        },
      ),
    );
  }
}
