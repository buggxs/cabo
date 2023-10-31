import 'package:cabo/components/main_menu/cubit/main_menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChoosePlayerAmountScreen extends StatelessWidget {
  const ChoosePlayerAmountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainMenuCubit cubit = context.watch<MainMenuCubit>();
    ChoosePlayerAmount state = cubit.state as ChoosePlayerAmount;

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
            color: Color.fromRGBO(90, 220, 51, 0.6509803921568628),
            shadowColor: Colors.black,
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Wieviele Spieler seit ihr?',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(
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
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        IconButton(
                          onPressed: cubit.decreasePlayerAmount,
                          icon: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: cubit.continueToPlayerNameScreen,
                    child: Text(
                      'Weiter',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
}
