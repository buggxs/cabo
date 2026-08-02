import 'package:cabo/common/presentation/widgets/cabo_primary_button.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/statistics/widgets/publish_stage.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLoading = false;

  Future<void> _handleSignIn(BuildContext context) async {
    final cubit = context.read<ApplicationCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final errorMessage = AppLocalizations.of(context)!.authScreenSignInFailed;
    setState(() => _isLoading = true);
    final success = await cubit.signInWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: CaboTheme.m3Error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

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
          if (_isLoading)
            CircularProgressIndicator(color: CaboTheme.m3Primary)
          else
            CaboPrimaryButton(
              label: l10n.authScreenSignInWithGoogle,
              onPressed: () => _handleSignIn(context),
              leading: SvgPicture.asset(
                'assets/images/google_logo.svg',
                height: 24,
                width: 24,
              ),
            ),
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
