import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:cabo/components/main_menu/widgets/cabo_round_button.dart';
import 'package:cabo/components/main_menu/widgets/menu_button.dart';
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
      color: Color.fromRGBO(81, 120, 30, 1.0),
      fontFamily: 'Aclonica',
      fontSize: 48,
      fontWeight: FontWeight.bold,
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

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                AppLocalizations.of(context)!.playerAmountDialogTitle,
                style: style,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 25,
                  ),
                  CaboRoundButton(
                    changePlayerAmount: cubit.increasePlayerAmount,
                  ),
                  const Spacer(),
                  Text(
                    '${state.playerAmount}',
                    style: style.copyWith(fontSize: 74),
                  ),
                  const Spacer(),
                  CaboRoundButton(
                    changePlayerAmount: cubit.decreasePlayerAmount,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                ],
              ),
              const Spacer(),
              MenuButton(
                text: AppLocalizations.of(context)!.continueText,
                onTap: cubit.continueToPlayerNameScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
