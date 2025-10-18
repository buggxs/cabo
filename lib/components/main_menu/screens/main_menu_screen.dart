import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/dark_screen_overlay.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_amount.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_name.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_screen_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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
  const MainMenuScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    MainMenuState state = cubit.state;

    Widget child = const MainMenuScreenList();

    if (state is ChoosePlayerAmount) {
      child = const DarkScreenOverlay(child: ChoosePlayerAmountScreen());
    } else if (state is ChoosePlayerNames) {
      child = const DarkScreenOverlay(child: ChoosePlayerNameScreen());
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: kDebugMode
              ? [
                  BlocBuilder<ApplicationCubit, ApplicationState>(
                    builder: (context, state) {
                      if (state is ApplicationAuthenticated) {
                        return IconButton(
                          onPressed: () {
                            context.read<ApplicationCubit>().signOut();
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: CaboTheme.primaryColor,
                          ),
                        );
                      }
                      return IconButton(
                        onPressed: () {
                          context.read<ApplicationCubit>().signInWithGoogle();
                        },
                        icon: const Icon(
                          Icons.login,
                          color: CaboTheme.primaryColor,
                        ),
                      );
                    },
                  ),
                ]
              : null,
        ),
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
