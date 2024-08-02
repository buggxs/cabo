import 'dart:convert';

import 'package:cabo/domain/game/game.dart';
import 'package:cabo/domain/open_game/open_game.dart';
import 'package:http/http.dart' as http;

abstract class OpenGameService {
  Future<OpenGame> publishGame(Game game);
}

class OnlineOpenGameService implements OpenGameService {
  @override
  Future<OpenGame> publishGame(Game game) {
    return http
        .post(
      Uri.parse(
        'http://cabo-web.eu-central-1.elasticbeanstalk.com/api/game/publish',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(game.toJson()),
    )
        .then((http.Response response) {
      return OpenGame.fromJson(jsonDecode(response.body));
    });
  }
}
