import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class FailureChip extends StatelessWidget {
  const FailureChip({super.key, required this.chipContent});

  final String chipContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: CaboTheme.primaryContainer,
      ),
      child: Text(
        chipContent,
        style: CaboTheme.labelSmallStyle.copyWith(
          color: CaboTheme.onPrimaryContainer,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
