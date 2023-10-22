import 'package:bloc/bloc.dart';

part 'statistics_state.dart';

enum PlayerType {
  playerOne,
  playerTwo,
  playerThree,
  playerFour,
  playerFive,
  playerSix
}

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsState());

  void increaseSum(int amount, PlayerType playerType) {
    switch (playerType) {
      case PlayerType.playerOne:
        int playerSum = state.sumPlayerOne + amount;
        emit(
          state.copyWith(sumPlayerOne: playerSum),
        );
        break;
      case PlayerType.playerTwo:
        int playerSum = state.sumPlayerTwo + amount;
        emit(
          state.copyWith(sumPlayerTwo: playerSum),
        );
        break;
      case PlayerType.playerThree:
        int playerSum = state.sumPlayerThree + amount;
        emit(
          state.copyWith(sumPlayerThree: playerSum),
        );
        break;
      case PlayerType.playerFour:
        // TODO: Handle this case.
        break;
      case PlayerType.playerFive:
        // TODO: Handle this case.
        break;
      case PlayerType.playerSix:
        // TODO: Handle this case.
        break;
    }
  }
}
