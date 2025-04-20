import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_amount.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_name.dart';
import 'package:cabo/components/main_menu/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_screen_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  static const String route = 'main_menu_screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainMenuCubit>(
      create: (_) => MainMenuCubit(),
      child: const MainMenuScreenContent(),
    );
  }
}

class MainMenuScreenContent extends StatelessWidget {
  const MainMenuScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    MainMenuState state = cubit.state;

    Widget child = const MainMenuScreenList();

    if (state is ChoosePlayerAmount) {
      child = const DarkScreenOverlay(
        child: ChoosePlayerAmountScreen(),
      );
    } else if (state is ChoosePlayerNames) {
      child = const DarkScreenOverlay(
        child: ChoosePlayerNameScreen(),
      );
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        cubit.onWillPop();
      },
      canPop: state is MainMenu,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/cabo-main-menu-background.png'),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: child,
        ),
      ),
    );
  }
}
