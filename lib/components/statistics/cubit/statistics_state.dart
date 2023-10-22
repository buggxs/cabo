part of 'statistics_cubit.dart';

class StatisticsState {
  StatisticsState({
    this.sumPlayerOne = 0,
    this.sumPlayerTwo = 0,
    this.sumPlayerThree = 0,
  });

  int sumPlayerOne;
  int sumPlayerTwo;
  int sumPlayerThree;

  StatisticsState copyWith({
    int? sumPlayerOne,
    int? sumPlayerTwo,
    int? sumPlayerThree,
  }) {
    return StatisticsState(
      sumPlayerOne: sumPlayerOne ?? this.sumPlayerOne,
      sumPlayerTwo: sumPlayerTwo ?? this.sumPlayerTwo,
      sumPlayerThree: sumPlayerThree ?? this.sumPlayerThree,
    );
  }
}
