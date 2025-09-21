part of 'main_menu_cubit.dart';

abstract class MainMenuState extends Equatable {
  const MainMenuState();
}

class MainMenu extends MainMenuState {
  @override
  List<Object> get props => [];
}

class ChoosePlayerAmount extends MainMenuState {
  const ChoosePlayerAmount({this.playerAmount = 3, this.shouldUseSpecialRules});

  final int playerAmount;
  final bool? shouldUseSpecialRules;

  ChoosePlayerAmount copyWith({int? playerAmount}) {
    return ChoosePlayerAmount(playerAmount: playerAmount ?? this.playerAmount);
  }

  @override
  List<Object?> get props => [playerAmount];
}

class ChoosePlayerNames extends MainMenuState {
  const ChoosePlayerNames({
    required this.playerAmount,
    this.playerNames = const <String>[],
    this.shouldUseSpecialRules,
  });

  final int playerAmount;
  final List<String> playerNames;
  final bool? shouldUseSpecialRules;

  ChoosePlayerNames copyWith({
    int? playerAmount,
    List<String>? playerNames,
    bool? shouldUseSpecialRules,
  }) {
    return ChoosePlayerNames(
      playerAmount: playerAmount ?? this.playerAmount,
      playerNames: playerNames ?? this.playerNames,
      shouldUseSpecialRules:
          shouldUseSpecialRules ?? this.shouldUseSpecialRules,
    );
  }

  @override
  List<Object?> get props => [playerAmount, playerNames];
}
