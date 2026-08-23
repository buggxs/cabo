import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_text_field.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/auth/auth_error_l10n.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/components/auth/widgets/auth_error_message.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailRegisterForm extends StatefulWidget {
  const EmailRegisterForm({super.key});

  @override
  State<EmailRegisterForm> createState() => _EmailRegisterFormState();
}

class _EmailRegisterFormState extends State<EmailRegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await context.read<AuthCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
      passwordRepeat: _repeatController.text,
    );
  }

  Future<void> _signInInstead() async {
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
          textInputAction: TextInputAction.next,
          autofillHints: const <String>[AutofillHints.newPassword],
        ),
        const SizedBox(height: 12),
        CaboTextField(
          controller: _repeatController,
          label: l10n.authScreenPasswordRepeat,
          isObscured: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
        if (state.hasEmailConflict) ...<Widget>[
          const SizedBox(height: 12),
          _EmailConflictNotice(
            onSignIn: state.isSubmitting ? null : _signInInstead,
          ),
        ],
        if (!state.hasEmailConflict) AuthErrorMessage(error: state.error),
        const SizedBox(height: 20),
        CaboPrimaryButton(
          label: l10n.authScreenRegister,
          onPressed: state.isSubmitting ? null : _submit,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: state.isSubmitting ? null : cubit.showSignIn,
          child: Text(l10n.authScreenAlreadyAccount),
        ),
        TextButton(
          onPressed: state.isSubmitting ? null : cubit.showChooser,
          child: Text(l10n.authScreenBack),
        ),
      ],
    );
  }
}

/// Offers signing in when the address already has an account. Deliberately an
/// explicit choice: signing in drops the anonymous UID, so games created on
/// this device stop being linked to the user.
class _EmailConflictNotice extends StatelessWidget {
  const _EmailConflictNotice({required this.onSignIn});

  final VoidCallback? onSignIn;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.authScreenEmailAlreadyInUse,
            style: CaboTheme.bodyMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.authScreenLinkConflictHint,
            style: CaboTheme.labelSmallStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: onSignIn,
            child: Text(l10n.authScreenSignIn),
          ),
        ],
      ),
    );
  }
}
