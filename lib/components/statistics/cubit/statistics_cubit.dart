import 'package:bloc/bloc.dart';
import 'package:cabo/core/app_service_locator.dart';
import 'package:cabo/domain/player/data/player.dart';
import 'package:cabo/domain/player/player_service.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsState());

  void getPlayers() async {
    List<Player> players = await app<PlayerService>().getPlayers();
    emit(
      state.copyWith(players: players),
    );
  }
}
