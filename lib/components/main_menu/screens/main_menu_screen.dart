import 'package:cabo/common/presentation/widgets/cabo_scaffold.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_amount.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_name.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_screen_list.dart';
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

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        cubit.onWillPop();
      },
      canPop: state is MainMenu,
      child: _buildBody(state),
    );
  }

  Widget _buildBody(MainMenuState state) {
    // Sub-Screens des Start-Flows behalten vorerst den bisherigen Look.
    if (state is ChoosePlayerAmount) {
      return CaboScaffold(
        withDarkOverlay: true,
        child: ChoosePlayerAmountScreen(),
      );
    }
    if (state is ChoosePlayerNames) {
      return CaboScaffold(
        withDarkOverlay: true,
        child: ChoosePlayerNameScreen(),
      );
    }

    // Neu gestaltete Landing-Page (helles Material-3-Design).
    return const Scaffold(body: MainMenuScreenList());
  }
}
