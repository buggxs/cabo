import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class CaboSwitch extends StatefulWidget {
  const CaboSwitch({
    this.initialValue = false,
    required this.labelText,
    this.onChanged,
    super.key,
  });

  final bool initialValue;
  final String labelText;
  final void Function(bool)? onChanged;

  @override
  State<CaboSwitch> createState() => _CaboSwitchState();
}

class _CaboSwitchState extends State<CaboSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AutoSizeText(
            widget.labelText,
            style: CaboTheme.primaryTextStyle.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Switch(
              trackColor: WidgetStateProperty.all(CaboTheme.tertiaryColor),
              trackOutlineColor:
                  WidgetStateProperty.all(CaboTheme.primaryColor),
              inactiveThumbColor: CaboTheme.secondaryColor,
              activeColor: CaboTheme.primaryColor,
              value: widget.initialValue,
              onChanged: (bool value) {
                widget.onChanged?.call(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
