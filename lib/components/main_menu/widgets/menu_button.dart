import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.text,
    this.onTap,
    this.onDoubleTap,
    this.padding,
    this.innerPadding,
    this.textStyle,
  });

  final String text;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;
  final TextStyle? textStyle;

  final TextStyle _style = const TextStyle(
    color: Color.fromRGBO(177, 218, 0, 1.0),
    fontFamily: 'Archivo',
    fontWeight: FontWeight.w800,
    fontSize: 32,
    height: 0,
  );

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null || onDoubleTap != null;

    final Color borderColor = isEnabled
        ? const Color.fromRGBO(177, 218, 0, 1.0)
        : Colors.grey.shade700;
    final TextStyle finalTextStyle = (textStyle ?? _style).copyWith(
      color: isEnabled ? (textStyle ?? _style).color : Colors.grey.shade500,
    );

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(3.0),
        child: GestureDetector(
          onDoubleTap: isEnabled ? onDoubleTap : null,
          onTap: isEnabled ? onTap : null,
          child: Container(
            padding: innerPadding ?? const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 45, 18, 1.0),
              border: Border.all(color: borderColor, width: 3.0),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Center(
              child: AutoSizeText(
                text,
                minFontSize: 8,
                maxFontSize: 32,
                softWrap: false,
                maxLines: 1,
                style: finalTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MenuFormButton extends StatelessWidget {
  const MenuFormButton({
    super.key,
    required this.text,
    this.onTap,
    this.padding,
    this.innerPadding,
    this.textStyle,
  });

  final String text;
  final void Function()? onTap;

  final EdgeInsets? padding;
  final EdgeInsets? innerPadding;
  final TextStyle? textStyle;

  final TextStyle _style = const TextStyle(
    color: Color.fromRGBO(177, 218, 0, 1.0),
    fontFamily: 'Archivo',
    fontWeight: FontWeight.w800,
    fontSize: 32,
    height: 0,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              innerPadding ?? const EdgeInsets.all(8.0),
            ),
            backgroundColor: const WidgetStatePropertyAll(
              CaboTheme.secondaryColor,
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(color: CaboTheme.primaryColorLight, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          child: Center(child: Text(text, style: textStyle ?? _style)),
        ),
      ),
    );
  }
}
