import 'dart:async';

import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/data/token.dart';
import 'package:drankroulette/local_preferences.dart';
import 'package:drankroulette/main.dart';
import 'package:drankroulette/views/base.dart';
import 'package:drankroulette/views/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  Widget build(BuildContext context) {
    if(kReleaseMode) {
      NewVersion nv = NewVersion(iOSAppStoreCountry: "NL");
      nv.showAlertIfNecessary(context: context);
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: CircularProgressIndicator()
            ),
          ),
          Center(
            child: Text(
              'Loading...',
              style: getDefaultTextStyle(),
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 2), () async {
      if(await getAppFingerprint() != null) {
        navigateHome();
        return;
      }

      Result tokenResult = await Token.generateToken();

      if(!mounted) {
        return;
      }

      if(!tokenResult.handleIfNotOk(context)) {
        return;
      }

      await setAppFingerprint(tokenResult.value!);
      navigateHome();
    });
  }

  void navigateHome() {
    Navigator
        .pushReplacement(context, MaterialPageRoute(builder: (builder) => const BaseView()));
  }
}