import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_text_field.dart';
import 'package:cabo/components/auth/auth_error_l10n.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/components/auth/widgets/auth_error_message.dart';
import 'package:cabo/components/auth/widgets/mail_delivery_hint.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({super.key});

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthCubit cubit = context.read<AuthCubit>();
    final AuthFormState state = context.watch<AuthCubit>().state;

    return Column(
      children: <Widget>[
        CaboTextField(
          controller: _emailController,
          label: l10n.authScreenEmail,
          errorText: state.emailFieldError?.message(l10n),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.email],
        ),
        const SizedBox(height: 12),
        CaboTextField(
          controller: _passwordController,
          label: l10n.authScreenPassword,
          errorText: state.passwordFieldError?.message(l10n),
          isObscured: true,
          textInputAction: TextInputAction.done,
          autofillHints: const <String>[AutofillHints.password],
          onSubmitted: (_) => _submit(),
        ),
        AuthErrorMessage(error: state.error),
        if (state.hasPasswordResetBeenSent) ...<Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              l10n.authScreenPasswordResetSent,
              textAlign: TextAlign.center,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.m3Primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const MailDeliveryHint(),
        ],
        const SizedBox(height: 20),
        CaboPrimaryButton(
          label: l10n.authScreenSignIn,
          onPressed: state.isSubmitting ? null : _submit,
        ),
        TextButton(
          onPressed: state.isSubmitting
              ? null
              : () => cubit.sendPasswordReset(_emailController.text),
          child: Text(l10n.authScreenForgotPassword),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: state.isSubmitting ? null : cubit.showRegister,
          child: Text(l10n.authScreenStartRegister),
        ),
        TextButton(
          onPressed: state.isSubmitting ? null : cubit.showChooser,
          child: Text(l10n.authScreenBack),
        ),
      ],
    );
  }
}
