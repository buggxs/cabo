import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/common/presentation/widgets/context_extensions.dart';
import 'package:cabo/components/about/about_screen.dart';
import 'package:cabo/components/application/cubit/application_cubit.dart';
import 'package:cabo/components/game_history/game_history_screen.dart';
import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_action_card.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_header.dart';
import 'package:cabo/components/main_menu/widgets/main_menu_utility_tile.dart';
import 'package:cabo/components/rule_set/rule_set_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenuScreenList extends StatelessWidget {
  const MainMenuScreenList({super.key});

  @override
  Widget build(BuildContext context) {
    final MainMenuCubit cubit = context.watch<MainMenuCubit>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 576),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const MainMenuHeader(),
                  const SizedBox(height: 32),
                  MainMenuActionCard(
                    icon: Icons.add_circle,
                    title: context.l10n.menuEntryTrackStats,
                    description: context.l10n.mainMenuStartBoardDescription,
                    backgroundColor: CaboTheme.primaryContainer,
                    foregroundColor: CaboTheme.onPrimaryContainer,
                    accentColor: CaboTheme.m3Primary,
                    decorationAsset: 'assets/images/background_button_icon.svg',
                    onTap: () => cubit.showChoosePlayerScreen(),
                  ),
                  const SizedBox(height: 16),
                  MainMenuActionCard(
                    icon: Icons.group_add,
                    title: context.l10n.menuEntryJoinGame,
                    description: context.l10n.mainMenuJoinBoardDescription,
                    backgroundColor: CaboTheme.m3Secondary,
                    foregroundColor: CaboTheme.onSecondary,
                    titleColor: CaboTheme.secondaryContainer,
                    accentColor: CaboTheme.onSecondaryFixedVariant,
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        context.read<ApplicationCubit>().signInAnonymously();
                      }
                      cubit.showJoinGameDialog(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  MainMenuUtilityTile(
                    icon: Icons.menu_book,
                    label: context.l10n.menuEntryGameRules,
                    onTap: () =>
                        cubit.pushToScreen(context, RuleSetScreen.route),
                  ),
                  const SizedBox(height: 16),
                  MainMenuUtilityTile(
                    icon: Icons.history,
                    label: context.l10n.menuEntryGameHistory,
                    onTap: () =>
                        cubit.pushToScreen(context, GameHistoryScreen.route),
                  ),
                  const SizedBox(height: 16),
                  MainMenuUtilityTile(
                    icon: Icons.info_outline,
                    label: context.l10n.menuEntryGameAboutScreen,
                    onTap: () =>
                        cubit.pushToScreen(context, AboutScreen.route),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
