// Path: lib/components/rating/rating_dialog.dart
// This file contains the rating dialog that appears after playing 3 games

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/core/app_navigator/navigation_service.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/misc/widgets/cabo_text_field.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  final void Function(int rating, String? feedback)? onSubmit;

  static Future<void> show({
    void Function(int rating, String? feedback)? onSubmit,
  }) async {
    return app<NavigationService>().showAppDialog(
      dialog: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(
            style: BorderStyle.solid,
            color: CaboTheme.tertiaryColor,
            width: 2,
          ),
        ),
        backgroundColor: CaboTheme.secondaryColor,
        child: RatingDialog(
          onSubmit: onSubmit,
        ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)?.rateAppTitle ?? 'Rate This App',
              style: CaboTheme.primaryTextStyle.copyWith(
                fontSize: 28,
                color: CaboTheme.primaryGreenColor,
                fontFamily: 'Archivo Black',
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            AutoSizeText(
              AppLocalizations.of(context)?.rateAppDescription ??
                  'How would you rate your experience with Cabo Board?',
              style: CaboTheme.secondaryTextStyle.copyWith(
                color: CaboTheme.primaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildStarRating(),
            const SizedBox(height: 16),
            CaboTextField(
              labelText: AppLocalizations.of(context)?.feedbackLabel ??
                  'Your Feedback (Optional)',
              maxLines: 4,
              minLines: 2,
              expand: false,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                // No need to set state, controller handles the value
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _selectedRating > 0
                        ? () {
                            if (widget.onSubmit != null) {
                              widget.onSubmit!(
                                  _selectedRating,
                                  _feedbackController.text.isNotEmpty
                                      ? _feedbackController.text
                                      : null);
                            }
                            Navigator.of(context).pop();
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: CaboTheme.primaryColor,
                      backgroundColor: CaboTheme.secondaryColor,
                      side: const BorderSide(
                          color: CaboTheme.primaryColor, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      disabledForegroundColor:
                          CaboTheme.tertiaryColor.withOpacity(0.5),
                      disabledBackgroundColor: CaboTheme.secondaryColor,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.submitRating ?? 'Submit',
                      style: CaboTheme.primaryTextStyle.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)?.maybeLater ?? 'Maybe Later',
                style: CaboTheme.secondaryTextStyle.copyWith(
                  color: CaboTheme.tertiaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
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
              color: CaboTheme.primaryColor,
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}
