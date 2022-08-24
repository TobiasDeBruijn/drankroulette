import 'dart:developer';

import 'package:drankroulette/components/display_game.dart';
import 'package:drankroulette/components/home/game_picker.dart';
import 'package:drankroulette/components/home/play_button.dart';
import 'package:drankroulette/data/game.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/main.dart';
import 'package:drankroulette/views/splash_screen.dart';
import 'package:drankroulette/views/text_popup.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'component.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    GamePickerComponent gamePickerComponent = GamePickerComponent();
    return Column(
      children: [
        gamePickerComponent,
        PlayButton(pickGameFunction: () {
          gamePickerComponent.startScrolling((game) {
            log("Game with name '${game.name}' was selected!");
            animatedPageTransition(
              context: context,
              page: ComponentView(component: DisplayGameComponent(game: game)),
              direction: AnimateDirection.up);
          });
        }),
        getDebugUi(),
      ],
    );
  }

  Widget getDebugUi() {
    if(kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: getDebugButtonStyle(),
              child: Text(
                "Open view game page",
                style: getDefaultTextStyle(),
              ),
              onPressed: () async {
                Result<List<Game>> gameResult = await GameApi.listGames(ignoreCache: true);
                if(!gameResult.isOk) {
                  showDialog(context: context, builder: (builder) => const TextPopupView(
                    text: "Unable to load games",
                  ));
                  return;
                }

                List<Game> games = gameResult.value!;
                if(games.isEmpty) {
                  showDialog(context: context, builder: (builder) => const TextPopupView(
                    text: "No games are available"
                  ));
                  return;
                }

                animatedPageTransition(
                  context: context,
                  page: ComponentView(component: DisplayGameComponent(game: games[0])),
                  direction: AnimateDirection.up
                );
              },
            ),
            ElevatedButton(
              style: getDebugButtonStyle(),
              child: Text(
                "Back to loading screen",
                style: getDefaultTextStyle(),
              ),
              onPressed: () {
                animatedPageTransition(
                  context: context,
                  page: const SplashScreenView(),
                  direction: AnimateDirection.sideFromLeft,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
