import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CaboTextField extends StatefulWidget {
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

  /// Obscured fields get a reveal toggle on the right.
  final bool isObscured;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<CaboTextField> createState() => _CaboTextFieldState();
}

class _CaboTextFieldState extends State<CaboTextField> {
  bool _isRevealed = false;

  bool get _isObscuringNow => widget.isObscured && !_isRevealed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      borderSide: BorderSide(color: CaboTheme.outlineVariant),
    );

    return TextField(
      controller: widget.controller,
      obscureText: _isObscuringNow,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      onSubmitted: widget.onSubmitted,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        filled: true,
        fillColor: CaboTheme.surfaceContainerLowest,
        suffixIcon: widget.isObscured
            ? IconButton(
                icon: Icon(
                  _isRevealed
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: CaboTheme.onSurfaceVariant,
                ),
                tooltip: _isRevealed
                    ? l10n.authScreenHidePassword
                    : l10n.authScreenShowPassword,
                onPressed: () => setState(() => _isRevealed = !_isRevealed),
              )
            : null,
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
