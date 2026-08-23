import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/auth/auth_error_l10n.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/components/auth/widgets/auth_provider_choice.dart';
import 'package:cabo/components/auth/widgets/email_register_form.dart';
import 'package:cabo/components/auth/widgets/email_sign_in_form.dart';
import 'package:cabo/components/auth/widgets/email_verification_notice.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Entry point for signing in. Provides the AuthCubit and switches between
/// the provider choice, the e-mail forms and the verification notice.
class AuthForm extends StatelessWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (BuildContext context) =>
          AuthCubit(applicationCubit: context.read<ApplicationCubit>()),
      child: const _AuthFormContent(),
    );
  }
}

class _AuthFormContent extends StatelessWidget {
  const _AuthFormContent();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthCubit cubit = context.read<AuthCubit>();
    final AuthFormState state = context.watch<AuthCubit>().state;
    final ApplicationState appState = context.watch<ApplicationCubit>().state;

    if (appState.isAwaitingEmailVerification) {
      return const EmailVerificationNotice();
    }

    return SingleChildScrollView(
      key: const ValueKey<String>('auth-form-view'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublishStage(
            child: SvgPicture.asset(
              'assets/images/cabo_card_icon.svg',
              height: 72,
              colorFilter: ColorFilter.mode(
                CaboTheme.m3Primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.authScreenSignInHeadline,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.authScreenSignInToPublish,
            textAlign: TextAlign.center,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          if (state.isSubmitting && state.mode == AuthMode.chooser)
            CircularProgressIndicator(color: CaboTheme.m3Primary)
          else
            _ModeContent(mode: state.mode, onGoogle: cubit.signInWithGoogle),
          if (state.error != null &&
              state.mode == AuthMode.chooser) ...<Widget>[
            const SizedBox(height: 12),
            Text(
              state.error!.message(l10n),
              textAlign: TextAlign.center,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.m3Error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.7,
            child: Text(
              l10n.authScreenSignInPrivacyHint,
              textAlign: TextAlign.center,
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

class _ModeContent extends StatelessWidget {
  const _ModeContent({required this.mode, required this.onGoogle});

  final AuthMode mode;
  final Future<bool> Function() onGoogle;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case AuthMode.chooser:
        return AuthProviderChoice(
          onGooglePressed: onGoogle,
          onEmailPressed: context.read<AuthCubit>().showSignIn,
        );
      case AuthMode.signIn:
        return const EmailSignInForm();
      case AuthMode.register:
        return const EmailRegisterForm();
    }
  }
}
