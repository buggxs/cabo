import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Points at the spam folder after an auth mail was sent.
///
/// Worth its own visible block rather than a footnote: the sending domain is
/// new, so mails do land in spam, and marking one as "not spam" is what makes
/// the next arrive.
class MailDeliveryHint extends StatelessWidget {
  const MailDeliveryHint({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.mark_email_read_outlined,
            size: 20,
            color: CaboTheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.authScreenMailSpamHint,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
