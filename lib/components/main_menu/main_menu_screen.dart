import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_amount.dart';
import 'package:cabo/components/main_menu/widgets/choose_player_name.dart';
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

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/cabo_bg_upscaled.png'),
          fit: BoxFit.cover,
        ),
      ),
      constraints: const BoxConstraints.expand(),
      child: child,
    );
  }

  Widget showMainMenuScreen(MainMenuCubit cubit) {
    const TextStyle style = TextStyle(
      color: Colors.yellow,
      fontFamily: 'Aclonica',
      fontSize: 24,
    );

    return SafeArea(
      child: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Image(
              image: AssetImage('assets/images/cabo_title.png'),
              height: 90,
              fit: BoxFit.fill,
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(
                          10.0,
                        ), // Innenabstand der Schaltfläche
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                                width: 50.0) // Abgerundete Ecken
                            ),
                        backgroundColor: const Color.fromRGBO(
                          238,
                          32,
                          32,
                          1.0,
                        ), // Hintergrundfarbe der Schaltfläche
                        side: const BorderSide(
                          color: Color.fromRGBO(217, 206, 0, 1.0), // Randfarbe
                          width: 2.0, // Breite des Randes
                        ),
                      ),
                      onPressed: () => cubit.showChoosePlayerAmountScreen(),
                      child: Text(
                        AppLocalizations.of(context)!.menuEntryTrackStats,
                        style: style,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(width: 50.0),
                        ),
                        backgroundColor: const Color.fromRGBO(238, 32, 32, 1.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(217, 206, 0, 1.0),
                          width: 2.0,
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.menuEntryGameHistory,
                        style: style,
                      ),
                    ),
                  ),
                ),
              ],
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
