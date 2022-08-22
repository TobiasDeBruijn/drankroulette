import 'dart:convert';
import 'dart:developer';

import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAppFingerprint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("AppFingerprint");
}

Future<void> setAppFingerprint(String fingerprint) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("AppFingerprint", fingerprint);
}

Future<List<Game>?> getCachedGames() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cachedGames64 = prefs.getString("CachedGames");
  if(cachedGames64 == null) {
    return null;
  }

  CachedGameStore cachedGameStore = CachedGameStore.fromBuffer(const Base64Decoder().convert(cachedGames64));
  int currentEpoch = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();

  if(currentEpoch >= cachedGameStore.epochTtl.toInt()) {
    log('Cached games have expired. Epoch ttl was ${cachedGameStore.epochTtl.toInt()}. Current epoch is $currentEpoch}');
    return null;
  }

  return cachedGameStore.games;
}

Future<void> setCachedGames(List<Game> games, {int ttl = 2592000}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Int64 epochTtl = Int64((DateTime.now().millisecondsSinceEpoch / 1000).ceil() + ttl);
  CachedGameStore cachedGameStore = CachedGameStore(
    games: games,
    epochTtl: epochTtl,
  );

  String cachedGames64 = const Base64Encoder().convert(cachedGameStore.writeToBuffer());
  prefs.setString("CachedGames", cachedGames64);
}