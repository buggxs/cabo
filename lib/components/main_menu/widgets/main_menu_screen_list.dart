import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:cabo/components/widgets/game_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MenuButton(
                            text: AppLocalizations.of(context)!
                                .menuEntryTrackStats,
                            onTap: () => cubit.showChoosePlayerAmountScreen(),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          MenuButton(
                            text:
                                AppLocalizations.of(context)!.menuEntryJoinGame,
                            onTap: () {
                              if (FirebaseAuth.instance.currentUser == null) {
                                context
                                    .read<ApplicationCubit>()
                                    .signInAnonymously();
                              }
                              cubit.showJoinGameDialog(context);
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: MenuButton(
                                  text: AppLocalizations.of(context)!
                                      .menuEntryGameRules,
                                  onTap: () => cubit.pushToScreen(
                                    context,
                                    RuleSetScreen.route,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: MenuButton(
                                  text: AppLocalizations.of(context)!
                                      .menuEntryGameHistory,
                                  onTap: () => cubit.pushToScreen(
                                    context,
                                    GameHistoryScreen.route,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          MenuButton(
                            text: AppLocalizations.of(context)!
                                .menuEntryGameAboutScreen,
                            onTap: () => cubit.pushToScreen(
                              context,
                              AboutScreen.route,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        );
      }),
    );
  }
}
