import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthProviderChoice extends StatelessWidget {
  const AuthProviderChoice({
    required this.onGooglePressed,
    required this.onEmailPressed,
    super.key,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onEmailPressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        CaboPrimaryButton(
          label: l10n.authScreenSignInWithGoogle,
          onPressed: onGooglePressed,
          leading: SvgPicture.asset(
            'assets/images/google_logo.svg',
            height: 24,
            width: 24,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onEmailPressed,
          icon: Icon(Icons.mail_outline, color: CaboTheme.m3Primary),
          label: Text(l10n.authScreenSignInWithEmail),
        ),
      ],
    );
  }
}
