import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:flutter/material.dart';

typedef IncreaseFunction = Function(int, PlayerType);

class InputCell extends StatefulWidget {
  InputCell({
    Key? key,
    this.textStyle,
    this.inputDecoration,
    this.controller,
    this.increaseFunction,
    this.playerType = PlayerType.playerOne,
    this.onSubmitted,
  }) : super(key: key) {
    controller ??= TextEditingController(text: '0');
  }

  final TextStyle? textStyle;
  final InputDecoration? inputDecoration;
  TextEditingController? controller;
  final IncreaseFunction? increaseFunction;
  final PlayerType playerType;
  final void Function()? onSubmitted;

  @override
  State<InputCell> createState() => _InputColumnState();
}

class _InputColumnState extends State<InputCell> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: const TextStyle(
        fontSize: 18,
      ),
      keyboardType: TextInputType.number,
      decoration: widget.inputDecoration,
      onTap: () {
        widget.controller?.text = '';
      },
      onSubmitted: (String val) {
        if (val.isNotEmpty) {
          widget.increaseFunction?.call(
            int.parse(val),
            widget.playerType,
          );
          widget.controller?.text = '0';
        }
        FocusManager.instance.primaryFocus?.unfocus();
        widget.onSubmitted?.call();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
