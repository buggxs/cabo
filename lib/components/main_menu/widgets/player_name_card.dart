import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:flutter/material.dart';

class PlayerNameCard extends StatelessWidget {
  const PlayerNameCard({
    required this.index,
    required this.controller,
    required this.badgeColor,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
    super.key,
  });

  final int index;
  final TextEditingController controller;
  final Color badgeColor;
  final bool canRemove;
  final VoidCallback onRemove;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: CaboTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          border: Border.all(color: CaboTheme.surfaceVariant),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: CaboTheme.cardShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              _buildBadge(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildHeader(context),
                    const SizedBox(height: 4),
                    _buildNameField(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '${index + 1}',
        style: CaboTheme.bodyLargeStyle.copyWith(
          color: CaboTheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${context.l10n.playerLabelPrefix} ${index + 1}',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CaboTheme.outline,
            ),
          ),
        ),
        if (canRemove)
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.close, size: 20, color: CaboTheme.outline),
            ),
          ),
      ],
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.words,
      cursorColor: CaboTheme.m3Primary,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
      decoration: InputDecoration(
        isDense: true,
        hintText: context.l10n.playerNameHint,
        hintStyle: CaboTheme.bodyMediumStyle.copyWith(
          color: CaboTheme.outlineVariant,
        ),
        filled: true,
        fillColor: CaboTheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          borderSide: BorderSide(color: CaboTheme.m3Primary, width: 2),
        ),
      ),
    );
  }
}
