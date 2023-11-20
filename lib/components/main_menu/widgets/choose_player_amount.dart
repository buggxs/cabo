import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChoosePlayerAmountScreen extends StatelessWidget {
  const ChoosePlayerAmountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    ChoosePlayerAmount state = cubit.state as ChoosePlayerAmount;

    const TextStyle style = TextStyle(
      color: Colors.black,
      fontFamily: 'Aclonica',
      fontSize: 18,
    );

    return SafeArea(
      child: Center(
        child: Card(
          color: const Color.fromRGBO(90, 220, 51, 0.6509803921568628),
          shadowColor: Colors.black,
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.playerAmountDialogTitle,
                  style: style,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: cubit.increasePlayerAmount,
                        icon: const Icon(Icons.add),
                      ),
                      Text(
                        '${state.playerAmount}',
                        style: style.copyWith(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: cubit.decreasePlayerAmount,
                        icon: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: cubit.continueToPlayerNameScreen,
                  child: Text(
                    AppLocalizations.of(context)!.continueText,
                    style: style.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
