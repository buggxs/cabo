import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthFormType { none, login, register }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthFormType _authFormType = AuthFormType.none;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 12),
            MenuButton(
              text: AppLocalizations.of(context)!.authScreenSignInWithEmail,
              onTap: () {
                setState(() {
                  _authFormType = AuthFormType.login;
                });
              },
              textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
            ),
          ],
          if (_authFormType == AuthFormType.login) _buildLoginForm(context),
          if (_authFormType == AuthFormType.register)
            _buildRegisterForm(context),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hintText: AppLocalizations.of(context)!.authScreenEmail,
          icon: Icons.email,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _passwordController,
          hintText: AppLocalizations.of(context)!.authScreenPassword,
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: AppLocalizations.of(context)!.authScreenSignIn,
          onTap: () async {
            String? error = await context
                .read<ApplicationCubit>()
                .signInWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );

            if (error != null) {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }
          },
          textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
        ),
        TextButton(
          onPressed: () =>
              setState(() => _authFormType = AuthFormType.register),
          child: Text(
            AppLocalizations.of(context)!.authScreenStartRegister,
            style: const TextStyle(color: CaboTheme.primaryColor, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _authFormType = AuthFormType.none;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.authScreenBack,
            style: const TextStyle(color: CaboTheme.primaryColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          hintText: AppLocalizations.of(context)!.authScreenEmail,
          icon: Icons.email,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _passwordController,
          hintText: AppLocalizations.of(context)!.authScreenPassword,
          icon: Icons.lock,
          obscureText: true,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _confirmPasswordController,
          hintText: AppLocalizations.of(context)!.authScreenPasswordRepeat,
          icon: Icons.lock_outline,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        MenuButton(
          text: AppLocalizations.of(context)!.authScreenRegister,
          onTap: () {
            if (_passwordController.text != _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.authScreenPasswortMissmatch,
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
              return;
            }
            context.read<ApplicationCubit>().registerWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );
          },
          textStyle: CaboTheme.primaryTextStyle.copyWith(fontSize: 18),
        ),
        TextButton(
          onPressed: () => setState(() => _authFormType = AuthFormType.login),
          child: Text(
            AppLocalizations.of(context)!.authScreenAlreadyAccount,
            style: const TextStyle(color: CaboTheme.primaryColor, fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _authFormType = AuthFormType.none;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.authScreenBack,
            style: const TextStyle(color: CaboTheme.primaryColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: CaboTheme.primaryColor),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: CaboTheme.primaryColor),
        hintText: hintText,
        hintStyle: TextStyle(
          color: CaboTheme.primaryColor.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: CaboTheme.secondaryBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: CaboTheme.tertiaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: CaboTheme.primaryColor),
        ),
      ),
    );
  }
}
