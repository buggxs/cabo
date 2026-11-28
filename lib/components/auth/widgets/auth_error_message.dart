import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/auth/auth_error_l10n.dart';
import 'package:cabo/domain/application/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';

/// Renders the form level error. Field level errors live on the inputs.
class AuthErrorMessage extends StatelessWidget {
  const AuthErrorMessage({required this.error, super.key});

  final AuthError? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        error!.message(context.l10n),
        textAlign: TextAlign.center,
        style: CaboTheme.labelSmallStyle.copyWith(color: CaboTheme.m3Error),
      ),
    );
  }
}
