import 'package:bloc/bloc.dart';
import 'package:cabo/components/statistics/statistics_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'main_menu_state.dart';

class MainMenuCubit extends Cubit<MainMenuState> {
  MainMenuCubit() : super(MainMenuInitial());

  void pushToStatsScreen(BuildContext context) {
    Navigator.of(context).pushNamed(StatisticsScreen.route);
  }
}
