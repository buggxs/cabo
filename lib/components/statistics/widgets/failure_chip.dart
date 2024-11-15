import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class FailureChip extends StatelessWidget {
  const FailureChip({
    super.key,
    required this.chipContent,
  });

  final String chipContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            CaboTheme.failureRed,
            CaboTheme.failureLightRed,
          ],
        ),
      ),
      child: Center(
        child: Text(
          chipContent,
          style: CaboTheme.numberTextStyle.copyWith(
            height: 0,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
