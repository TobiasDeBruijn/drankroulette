import 'dart:io';
import 'dart:developer';

import 'package:drankroulette/data/api.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/data/proto/payload/game/create.pbserver.dart';
import 'package:drankroulette/data/proto/payload/game/list.pb.dart';
import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/local_preferences.dart';
import 'package:http/http.dart' as http;

class GameApi {
  static Future<Result<Game>> getGame(String id) async {
    return Result.err();
  }

  static Future<Result<List<Game>>> listGames({bool ignoreCache = false}) async {
    log("Getting available games");

    List<Game>? maybeCachedGames = await getCachedGames();
    if(maybeCachedGames != null && !ignoreCache) {
      log("Returning games from cache");
      return Result.ok(maybeCachedGames);
    }

    log("Retrieving available games from server");
    try {
      http.Response response = await http.get(Uri.parse("$SERVER/v1/game/list"),
        headers: getDefaultHeaders((await getAppFingerprint())!)
      );

      switch(response.statusCode) {
        case 200:
          GetGameListResponse getGameListResponse = GetGameListResponse.fromBuffer(response.bodyBytes);
          await setCachedGames(getGameListResponse.games);
          return Result.ok(getGameListResponse.games);
        default:
          log(response.statusCode.toString());
          return Result.err();
      }
    } on SocketException catch(e) {
      log(e.toString());
      return Result.err();
    }
  }

  static Future<Result<String>> createGame(Game game) async {
    log("Creating game $game");

    try {
      PostGameCreateRequest createRequest = PostGameCreateRequest(game: game);

      http.Response response = await http.post(Uri.parse("$SERVER/v1/game/create"),
        headers: getDefaultHeaders((await getAppFingerprint())!),
        body: createRequest.writeToBuffer(),
      );

      switch(response.statusCode) {
        case 200:
          PostGameCreateResponse responseBody = PostGameCreateResponse.fromBuffer(response.bodyBytes);
          return Result.ok(responseBody.id);
        default:
          log(response.statusCode.toString());
          return Result.err();
      }
    } on SocketException catch(e) {
      log(e.toString());
      return Result.err();
    }
  }
}