import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key, this.onSubmit});

  final void Function(int rating, String? feedback)? onSubmit;

  static Future<void> show({
    void Function(int rating, String? feedback)? onSubmit,
  }) async {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) => Dialog(
        backgroundColor: CaboTheme.surfaceContainerLowest,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: RatingDialog(onSubmit: onSubmit),
      ),
    );
  }

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeaderIcon(),
            const SizedBox(height: 20),
            Text(
              l10n?.rateAppTitle ?? 'Rate This App',
              style: CaboTheme.headlineMediumStyle.copyWith(
                color: CaboTheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AutoSizeText(
              l10n?.rateAppDescription ??
                  'How would you rate your experience with Cabo Board?',
              style: CaboTheme.bodyLargeStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildStarRating(),
            const SizedBox(height: 20),
            _buildFeedbackField(l10n),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CaboPrimaryButton(
                label: l10n?.submitRating ?? 'Submit',
                onPressed: _selectedRating > 0 ? _submit : null,
              ),
            ),
            const SizedBox(height: 8),
            _buildMaybeLaterButton(l10n),
          ],
        ),
      ),
    );
  }

  void _submit() {
    widget.onSubmit?.call(
      _selectedRating,
      _feedbackController.text.isNotEmpty ? _feedbackController.text : null,
    );
    app<NavigationService>().pop<void>();
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: CaboTheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.star_rounded,
        size: 32,
        color: CaboTheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildFeedbackField(AppLocalizations? l10n) {
    return TextField(
      controller: _feedbackController,
      minLines: 2,
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
      decoration: InputDecoration(
        labelText: l10n?.feedbackLabel ?? 'Your Feedback (Optional)',
        labelStyle: CaboTheme.bodyMediumStyle.copyWith(
          color: CaboTheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: CaboTheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.all(12),
        border: _feedbackBorder(CaboTheme.outlineVariant),
        enabledBorder: _feedbackBorder(CaboTheme.outlineVariant),
        focusedBorder: _feedbackBorder(CaboTheme.m3Primary, width: 2),
      ),
    );
  }

  OutlineInputBorder _feedbackBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildMaybeLaterButton(AppLocalizations? l10n) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => app<NavigationService>().pop<void>(),
        style: TextButton.styleFrom(
          foregroundColor: CaboTheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          ),
        ),
        child: Text(
          l10n?.maybeLater ?? 'Maybe Later',
          style: CaboTheme.labelLargeStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(5, (int index) {
        final int starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedRating = starIndex;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              starIndex <= _selectedRating ? Icons.star : Icons.star_border,
              color: CaboTheme.m3Tertiary,
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}
