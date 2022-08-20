import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getAppFingerprint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("AppFingerprint");
}

Future<void> setAppFingerprint(String fingerprint) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("AppFingerprint", fingerprint);
}