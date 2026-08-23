import 'package:cabo/domain/application/auth_service.dart';
import 'package:cabo/l10n/app_localizations.dart';

extension AuthErrorL10n on AuthError {
  String message(AppLocalizations l10n) {
    switch (this) {
      case AuthError.passwordMismatch:
        return l10n.authScreenPasswortMissmatch;
      case AuthError.invalidCredentials:
        return l10n.authScreenInvalidCredentials;
      case AuthError.emailAlreadyInUse:
      case AuthError.credentialAlreadyInUse:
      case AuthError.providerAlreadyLinked:
        return l10n.authScreenEmailAlreadyInUse;
      case AuthError.weakPassword:
        return l10n.authScreenWeakPassword;
      case AuthError.invalidEmail:
        return l10n.authScreenInvalidEmail;
      case AuthError.tooManyRequests:
        return l10n.authScreenTooManyRequests;
      case AuthError.network:
        return l10n.authScreenNetworkError;
      case AuthError.cancelled:
      case AuthError.unknown:
        return l10n.authScreenSignInFailed;
    }
  }
}
