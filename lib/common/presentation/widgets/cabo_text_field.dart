import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';

class CaboTextField extends StatefulWidget {
  const CaboTextField({
    this.value,
    this.labelText,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.expand,
    this.keyboardType,
    super.key,
  });

  final String? labelText;
  final String? value;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool? expand;
  final TextInputType? keyboardType;

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
    _controller = TextEditingController(text: widget.value);
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
    _controller.text = widget.value ?? _controller.text;

    return TextField(
      keyboardType: widget.keyboardType ?? TextInputType.number,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expand ?? false,
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
        alignLabelWithHint: true,
        labelText: widget.labelText,
      ),
    );
  }

  void _onFocusChanged() {
    setState(() {
      currentBackgroundColor = _focus.hasFocus
          ? CaboTheme.tertiaryColor
          : Colors.transparent;
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

class CaboTextFormField extends StatefulWidget {
  const CaboTextFormField({
    required this.controller,
    this.labelText,
    this.onChanged,
    this.maxLines,
    this.minLines,
    this.expand,
    this.keyboardType,
    super.key,
  });

  final String? labelText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;
  final bool? expand;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  @override
  State<CaboTextFormField> createState() => _CaboTextFormFieldState();
}

class _CaboTextFormFieldState extends State<CaboTextFormField> {
  Color currentBackgroundColor = CaboTheme.tertiaryColor;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller.text.isEmpty) {
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
    return TextFormField(
      keyboardType: widget.keyboardType ?? TextInputType.number,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expand ?? false,
      controller: widget.controller,
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
        alignLabelWithHint: true,
        labelText: widget.labelText,
      ),
    );
  }

  void _onFocusChanged() {
    setState(() {
      currentBackgroundColor = _focus.hasFocus
          ? CaboTheme.tertiaryColor
          : Colors.transparent;
    });
  }

  void adjustBackgroundColor() {
    if (widget.controller.text.isNotEmpty) {
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
