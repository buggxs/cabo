import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/misc/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoosePlayerNameScreen extends StatelessWidget {
  const ChoosePlayerNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    ChoosePlayerNames state = cubit.state as ChoosePlayerNames;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/cabo_bg_upscaled.png'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
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
                    const Text(
                      'Wie heißen die Spieler?',
                      style: TextStyle(color: Colors.white, fontSize: 24),
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
                      child: const Text(
                        'Starten',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
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
      final String playerDefaultName = 'Player $i';
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
