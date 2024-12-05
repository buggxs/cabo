import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.text,
    this.onTap,
    this.onDoubleTap,
    this.padding,
    this.innerPadding,
    this.textStyle,
  }) : super(key: key);

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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(3.0),
        child: GestureDetector(
          onDoubleTap: onDoubleTap,
          onTap: onTap,
          child: Container(
            padding: innerPadding ?? const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(32, 45, 18, 1.0),
              border: Border.all(
                color: const Color.fromRGBO(177, 218, 0, 1.0),
                width: 3.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Center(
              child: Text(
                text,
                style: textStyle ?? _style,
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
    Key? key,
    required this.text,
    this.onTap,
    this.padding,
    this.innerPadding,
    this.textStyle,
  }) : super(key: key);

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
            backgroundColor:
                const WidgetStatePropertyAll(CaboTheme.secondaryColor),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: CaboTheme.primaryColorLight,
                  width: 3,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: textStyle ?? _style,
            ),
          ),
        ),
      ),
    );
  }
}
