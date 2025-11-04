import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthFormType { none, login, register }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final AuthFormType _authFormType = AuthFormType.none;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
            child: Text(
              AppLocalizations.of(context)!.authScreenSignInToPublish,
              textAlign: TextAlign.center,
              style: CaboTheme.primaryTextStyle.copyWith(fontSize: 28),
            ),
          ),
          if (_authFormType == AuthFormType.none) ...[
            MenuButton(
              text: AppLocalizations.of(context)!.authScreenSignInWithGoogle,
              onTap: () {
                context.read<ApplicationCubit>().signInWithGoogle();
              },
              textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
            ),
          ],
        ],
      ),
    );
  }
}
