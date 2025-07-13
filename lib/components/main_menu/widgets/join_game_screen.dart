import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/widgets/cabo_scanner_window.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinGameScreen extends StatelessWidget {
  const JoinGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 24,
            color: CaboTheme.primaryColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.menuEntryJoinGame,
          style: CaboTheme.secondaryTextStyle.copyWith(
            fontSize: 38,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(children: [
            const CaboScannerWindow(),
            MenuButton(
              text: 'Spiel beitreten',
              onTap: () {
                context.read<ApplicationCubit>().signInWithGoogle();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
