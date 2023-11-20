import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePlayerNameScreen extends StatelessWidget {
  const ChoosePlayerNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      color: Colors.black,
      fontFamily: 'Aclonica',
      fontSize: 18,
    );

    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    ChoosePlayerNames state = cubit.state as ChoosePlayerNames;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Center(
        child: Card(
          color: const Color.fromRGBO(90, 220, 51, 0.6509803921568628),
          shadowColor: Colors.black,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.playerNames,
                    style: style.copyWith(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ...buildTextFields(state.playerAmount, cubit),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () => cubit.startGame(context, formKey),
                    child: Text(
                      AppLocalizations.of(context)!.start,
                      style: style.copyWith(fontSize: 22.0),
                    ),
                  ),
                ],
              ),
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
          width: 200,
          child: Focus(
            child: TextFormField(
              controller: controller,
              autocorrect: false,
              enableSuggestions: false,
              decoration: dialogPointInputStyle,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Aclonica',
                fontSize: 18,
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
