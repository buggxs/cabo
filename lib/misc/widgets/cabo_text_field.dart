import 'package:cabo/misc/utils/dialogs.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class CaboTextField extends StatefulWidget {
  const CaboTextField({
    this.value,
    this.labelText,
    this.onChanged,
    super.key,
  });

  final String? labelText;
  final String? value;
  final void Function(String)? onChanged;

  @override
  State<CaboTextField> createState() => _CaboTextFieldState();
}

class _CaboTextFieldState extends State<CaboTextField> {
  Color currentBackgroundColor = CaboTheme.tertiaryColor;
  final FocusNode _focus = FocusNode();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value,
    );
    if (widget.value?.isEmpty ?? true) {
      currentBackgroundColor = Colors.transparent;
    }
    _focus.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChanged);
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.value ?? '';

    return TextField(
      keyboardType: TextInputType.number,
      onChanged: (String points) {
        if (points.isNotEmpty) {
          setState(() {
            currentBackgroundColor = CaboTheme.tertiaryColor;
          });
          widget.onChanged?.call(points);
        } else {
          setState(() {
            currentBackgroundColor = Colors.transparent;
          });
        }
      },
      controller: _controller,
      focusNode: _focus,
      minLines: 1,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Aclonica',
        color: CaboTheme.primaryColor,
      ),
      decoration: dialogPointInputStyle.copyWith(
        labelStyle: CaboTheme.secondaryTextStyle.copyWith(
          fontSize: 14,
          color: CaboTheme.primaryColor,
          backgroundColor: currentBackgroundColor,
        ),
        labelText: widget.labelText,
      ),
    );
  }

  void _onFocusChanged() {
    setState(() {
      currentBackgroundColor =
          _focus.hasFocus ? CaboTheme.tertiaryColor : Colors.transparent;
    });
  }

  void adjustBackgroundColor() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        currentBackgroundColor = CaboTheme.tertiaryColor;
      });
    } else {
      setState(() {
        currentBackgroundColor = Colors.transparent;
      });
    }
  }
}
