part of 'game_history_cubit.dart';

class GameHistoryState extends Equatable {
  const GameHistoryState({this.games = const <Game>[]});

  final List<Game> games;

  GameHistoryState copyWith({List<Game>? games}) {
    return GameHistoryState(games: games ?? this.games);
  }

  @override
  List<Object?> get props => [games];
}
