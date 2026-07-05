part of 'main_menu_cubit.dart';

abstract class MainMenuState extends Equatable {
  const MainMenuState();
}

class MainMenu extends MainMenuState {
  @override
  List<Object> get props => [];
}

class ChoosePlayers extends MainMenuState {
  const ChoosePlayers({
    this.recentGroups = const <PlayerGroup>[],
    this.shouldUseSpecialRules,
  });

  final List<PlayerGroup> recentGroups;
  final bool? shouldUseSpecialRules;

  @override
  List<Object?> get props => [recentGroups, shouldUseSpecialRules];
}
