import 'dart:io';
import 'dart:developer';

import 'package:drankroulette/data/api.dart';
import 'package:drankroulette/data/proto/payload/token/generate.pbserver.dart';
import 'package:drankroulette/data/result.dart';
import 'package:http/http.dart' as http;

class Token {
  static Future<Result<String>> generateToken() async {
    log("Requesting server for token");

    try {
      http.Response response = await http.post(Uri.parse("$SERVER/v1/token/generate"),
        headers: getProtobufHeaders()
      );

      switch(response.statusCode) {
        case 200:
          return Result.ok(PostGenerateTokenResponse.fromBuffer(response.bodyBytes).token);

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