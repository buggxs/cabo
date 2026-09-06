import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ApplicationState state = context.watch<ApplicationCubit>().state;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x143D3A35),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.accountCardTitle,
            textAlign: TextAlign.center,
            style: CaboTheme.headlineMediumStyle.copyWith(
              color: CaboTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          if (state.hasAccount)
            _AccountDetails(
              email: state.email ?? '',
              isEmailVerified: state.isEmailVerified,
            )
          else
            const _AnonymousHint(),
          if (state.hasAccount) ...<Widget>[
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => context.read<ApplicationCubit>().signOut(),
              icon: Icon(Icons.logout, color: CaboTheme.m3Primary),
              label: Text(context.l10n.accountCardSignOut),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccountDetails extends StatelessWidget {
  const _AccountDetails({required this.email, required this.isEmailVerified});

  final String email;
  final bool isEmailVerified;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          email,
          textAlign: TextAlign.center,
          style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              isEmailVerified ? Icons.verified : Icons.error_outline,
              size: 16,
              color: isEmailVerified ? CaboTheme.m3Primary : CaboTheme.m3Error,
            ),
            const SizedBox(width: 6),
            Text(
              isEmailVerified
                  ? context.l10n.accountCardVerified
                  : context.l10n.accountCardUnverified,
              style: CaboTheme.labelSmallStyle.copyWith(
                color: isEmailVerified
                    ? CaboTheme.onSurfaceVariant
                    : CaboTheme.m3Error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnonymousHint extends StatelessWidget {
  const _AnonymousHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          context.l10n.accountCardAnonymous,
          textAlign: TextAlign.center,
          style: CaboTheme.bodyMediumStyle.copyWith(color: CaboTheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.accountCardAnonymousHint,
          textAlign: TextAlign.center,
          style: CaboTheme.labelSmallStyle.copyWith(
            color: CaboTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
