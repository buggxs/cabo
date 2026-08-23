import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class CaboTextField extends StatelessWidget {
  const CaboTextField({
    required this.controller,
    required this.label,
    this.errorText,
    this.isObscured = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool isObscured;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      borderSide: BorderSide(color: CaboTheme.outlineVariant),
    );

    return TextField(
      controller: controller,
      obscureText: isObscured,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onSubmitted: onSubmitted,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        filled: true,
        fillColor: CaboTheme.surfaceContainerLowest,
        labelStyle: CaboTheme.bodyMediumStyle.copyWith(
          color: CaboTheme.onSurfaceVariant,
        ),
        errorStyle: CaboTheme.labelSmallStyle.copyWith(
          color: CaboTheme.m3Error,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: CaboTheme.m3Primary, width: 2),
        ),
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: CaboTheme.m3Error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: BorderSide(color: CaboTheme.m3Error, width: 2),
        ),
      ),
    );
  }
}
