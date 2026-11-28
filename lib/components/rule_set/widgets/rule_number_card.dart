import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/rule_set/widgets/rule_card.dart';
import 'package:flutter/material.dart';

/// Rule card with a numeric points input that is validated against an
/// optional upper bound.
class RuleNumberCard extends StatelessWidget {
  const RuleNumberCard({
    required this.title,
    required this.description,
    required this.suffix,
    required this.controller,
    this.maxValue,
    super.key,
  });

  final String title;
  final String description;
  final String suffix;
  final TextEditingController controller;
  final int? maxValue;

  @override
  Widget build(BuildContext context) {
    return RuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.m3Primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _buildPointsField(),
        ],
      ),
    );
  }

  Widget _buildPointsField() {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: CaboTheme.m3Primary,
      style: CaboTheme.headlineMediumStyle.copyWith(color: CaboTheme.onSurface),
      validator: _validatePoints,
      decoration: InputDecoration(
        filled: true,
        fillColor: CaboTheme.surfaceContainer,
        suffixText: suffix,
        suffixStyle: CaboTheme.labelLargeStyle.copyWith(
          color: CaboTheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          borderSide: BorderSide(color: CaboTheme.primaryContainer, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          borderSide: BorderSide(color: CaboTheme.m3Error),
        ),
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }

  String? _validatePoints(String? value) {
    final int? points = value == null ? null : int.tryParse(value);
    if (points == null || points < 0) {
      return '';
    }
    if (maxValue != null && points > maxValue!) {
      return '';
    }
    return null;
  }
}
