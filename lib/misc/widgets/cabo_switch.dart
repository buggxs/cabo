import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class CaboSwitch extends StatefulWidget {
  const CaboSwitch({
    this.initialValue = false,
    required this.labelText,
    super.key,
  });

  final bool? initialValue;
  final String labelText;

  @override
  State<CaboSwitch> createState() => _CaboSwitchState();
}

class _CaboSwitchState extends State<CaboSwitch> {
  bool active = false;

  @override
  void initState() {
    super.initState();
    active = widget.initialValue!;
  }

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
              value: active,
              onChanged: (bool value) {
                setState(() {
                  active = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
