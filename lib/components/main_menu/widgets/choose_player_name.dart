import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePlayerNameScreen extends StatelessWidget {
  const ChoosePlayerNameScreen({Key? key}) : super(key: key);

  static const TextStyle style = TextStyle(
    color: Color.fromRGBO(81, 120, 30, 1.0),
    fontFamily: 'Aclonica',
    fontSize: 48,
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
    ChoosePlayerNames state = cubit.state as ChoosePlayerNames;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  AppLocalizations.of(context)!.playerNames,
                  style: style,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ...buildTextFields(state.playerAmount, cubit),
                      ],
                    ),
                  ),
                ),
                MenuButton(
                  text: AppLocalizations.of(context)!.start,
                  onTap: () => cubit.startGame(context, formKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildTextFields(int playerAmount, MainMenuCubit cubit) {
    List<Widget> childList = <Widget>[];

    for (int i = 0; i < playerAmount; i++) {
      final String playerDefaultName = 'Player ${i + 1}';
      final TextEditingController controller =
          TextEditingController(text: playerDefaultName);
      Widget child = Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 250,
          child: Focus(
            child: TextFormField(
              controller: controller,
              autocorrect: false,
              enableSuggestions: false,
              cursorColor: const Color.fromRGBO(81, 120, 30, 1.0),
              decoration: dialogPointInputStyle,
              style: const TextStyle(
                color: Color.fromRGBO(81, 120, 30, 1.0),
                fontFamily: 'Aclonica',
                fontSize: 20,
              ),
              onSaved: (String? name) {
                String? submittedName = name;
                if (submittedName?.isEmpty ?? true) {
                  submittedName = playerDefaultName;
                }
                cubit.submitPlayerName(submittedName!);
              },
            ),
            onFocusChange: (bool hasFocus) {
              if (hasFocus) {
                controller.text = '';
              }
            },
          ),
        ),
      );
      childList.add(child);
    }

    return childList;
  }
}
