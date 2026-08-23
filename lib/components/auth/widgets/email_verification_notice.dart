import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/auth/cubit/auth_cubit.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shown while the account exists but the address is not confirmed yet.
///
/// Re-checks on resume, which is what makes the flow work even when the
/// deep link does not open the app.
class EmailVerificationNotice extends StatefulWidget {
  const EmailVerificationNotice({super.key});

  @override
  State<EmailVerificationNotice> createState() =>
      _EmailVerificationNoticeState();
}

class _EmailVerificationNoticeState extends State<EmailVerificationNotice> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onResume: _refreshStatus);
    // Also check on mount: the address may have been confirmed while this
    // screen was closed.
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshStatus());
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _refreshStatus() {
    if (!mounted) return;
    context.read<AuthCubit>().checkVerification();
  }

  Future<void> _checkNow() async {
    final AuthCubit cubit = context.read<AuthCubit>();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final bool isVerified = await cubit.checkVerification();
    if (!mounted || isVerified) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.verifyEmailStillPending)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AuthCubit cubit = context.read<AuthCubit>();
    final AuthFormState state = context.watch<AuthCubit>().state;
    final String email =
        context.watch<ApplicationCubit>().state.email ?? l10n.authScreenEmail;

    return SingleChildScrollView(
      key: const ValueKey<String>('email-verification-view'),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PublishStage(
            child: Icon(
              Icons.mark_email_unread_outlined,
              size: 72,
              color: CaboTheme.m3Primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.verifyEmailTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.verifyEmailDescription(email),
            textAlign: TextAlign.center,
            style: CaboTheme.bodyLargeStyle.copyWith(
              color: CaboTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          if (state.isSubmitting)
            CircularProgressIndicator(color: CaboTheme.m3Primary)
          else
            CaboPrimaryButton(
              label: l10n.verifyEmailCheckNow,
              onPressed: _checkNow,
            ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: state.canResendVerification
                ? cubit.resendVerificationEmail
                : null,
            child: Text(
              state.resendCooldown > 0
                  ? l10n.verifyEmailResendIn(state.resendCooldown)
                  : l10n.verifyEmailResend,
            ),
          ),
          if (state.wasVerificationResent)
            Text(
              l10n.verifyEmailResent,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: CaboTheme.m3Primary,
              ),
            ),
          const SizedBox(height: 8),
          Opacity(
            opacity: 0.7,
            child: Text(
              l10n.verifyEmailSpamHint,
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
