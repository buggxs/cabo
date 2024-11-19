import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/widgets/game_header.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuScreenList extends StatelessWidget {
  const MainMenuScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    return SafeArea(
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const GameHeader(),
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
                    onTap: () => cubit.pushToScreen(
                      context,
                      GameHistoryScreen.route,
                    ),
                  ),
                  MenuButton(
                    text: AppLocalizations.of(context)!.menuEntryGameRules,
                    onTap: () => cubit.pushToScreen(
                      context,
                      RuleSetScreen.route,
                    ),
                  ),
                  MenuButton(
                    text:
                        AppLocalizations.of(context)!.menuEntryGameAboutScreen,
                    onTap: () => cubit.pushToScreen(
                      context,
                      AboutScreen.route,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              '© Andre Salzmann 2025',
              style: CaboTheme.primaryTextStyle.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        );
      }),
    );
  }
}
