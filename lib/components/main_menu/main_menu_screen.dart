import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_amount.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_name.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  static const String route = 'statistic_tracker_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<MainMenuCubit>(
        create: (_) => MainMenuCubit(),
        child: const MainMenuScreenContent(),
      ),
    );
  }
}

class MainMenuScreenContent extends StatelessWidget {
  const MainMenuScreenContent({Key? key}) : super(key: key);

  static const TextStyle style = TextStyle(
    color: Color.fromRGBO(81, 120, 30, 1.0),
    fontFamily: 'Aclonica',
    fontSize: 74,
    fontWeight: FontWeight.bold,
    letterSpacing: 10.0,
    shadows: [
      Shadow(
        color: Color.fromRGBO(32, 45, 18, 1.0),
        blurRadius: 2.0,
        offset: Offset(
          2.0,
          2.0,
        ),
      ),
      Shadow(
        color: Color.fromRGBO(32, 45, 18, 1.0),
        blurRadius: 2.0,
        offset: Offset(
          2.0,
          -2.0,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    MainMenuState state = cubit.state;

    Widget child = showMainMenuScreen(cubit);

    if (state is ChoosePlayerAmount) {
      child = const ChoosePlayerAmountScreen();
    } else if (state is ChoosePlayerNames) {
      child = const ChoosePlayerNameScreen();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo-main-menu-background.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: PopScope(
          onPopInvoked: (_) => cubit.onWillPop,
          child: child,
        ),
      ),
    );
  }

  Widget showMainMenuScreen(MainMenuCubit cubit) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SizedBox(
                        height: 250,
                        width: 300,
                        child: Text(
                          AppLocalizations.of(context)!.gameName,
                          style: style,
                        ),
                      ),
                      Positioned(
                        top: 60,
                        right: 60,
                        child: Text(
                          AppLocalizations.of(context)!.gameSubTitle,
                          style: style.copyWith(
                            fontSize: 48,
                            letterSpacing: 1,
                            color: const Color.fromRGBO(187, 208, 0, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SingleChildScrollView(
              child: Column(
                children: [
                  MenuButton(
                    text: AppLocalizations.of(context)!.menuEntryTrackStats,
                    onTap: () => cubit.showChoosePlayerAmountScreen(),
                    onDoubleTap: () {
                      cubit.showChoosePlayerAmountScreen(
                        useOwnRuleSet: true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.loadedOwnRules),
                        ),
                      );
                    },
                  ),
                  MenuButton(
                    text: AppLocalizations.of(context)!.menuEntryGameHistory,
                    onTap: () => cubit.pushToGameHistoryScreen(context),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ),
          ],
        );
      }),
    );
  }
}
