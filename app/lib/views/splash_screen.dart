import 'dart:async';

import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/data/token.dart';
import 'package:drankroulette/local_preferences.dart';
import 'package:drankroulette/main.dart';
import 'package:drankroulette/views/base.dart';
import 'package:drankroulette/views/home.dart';
import 'package:drankroulette/views/text_popup.dart';
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
    if (kReleaseMode) {
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
            child: Center(child: CircularProgressIndicator()),
          ),
          Center(
            child: Text(
              'Loading...',
              style: getDefaultTextStyle(),
            ),
          ),
          getDebugNavigation(),
        ],
      )
    );
  }

  Widget getDebugNavigation() {
    if (kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            )
          ),
          child: Text(
            "Open server unavailable dialog",
            style: getDefaultTextStyle(),
          ),
          onPressed: () => openServerConnectionIssueDialog(),
        ),
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            )
          ),
          child: Text(
            "Continue",
            style: getDefaultTextStyle(),
          ),
          onPressed: () => navigateHome(),
        )
      ]
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void openServerConnectionIssueDialog() {
    showDialog(context: context, builder: (builder) => const TextPopupView(
      text: "Unable to establish connection to the server."
    ));
  }

  void startTimer() {
    Timer(const Duration(seconds: 2), () async {
      if (await getAppFingerprint() != null) {
        if(kReleaseMode) {
          navigateHome();
        }
        
        return;
      }

      Result tokenResult = await Token.generateToken();

      if (!mounted) {
        return;
      }

      if(!tokenResult.isOk) {
        openServerConnectionIssueDialog();
        return;
      }

      await setAppFingerprint(tokenResult.value!);

      if(kReleaseMode) {
        navigateHome();
      }
    });
  }

  void navigateHome() {
    animatedPageTransition(
      context: context,
      page: const BaseView(),
      direction: AnimateDirection.sideFromRight,
      replace: true
    );
  }
}
