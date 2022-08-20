import 'package:flutter/foundation.dart';

const String SERVER = kReleaseMode
  ? "TODO"
  : "http://192.168.1.52:8080";

Map<String, String> getProtobufHeaders() {
  return {
    'Content-Type': 'application/protobuf',
    'Accept': 'application/protobuf'
  };
}