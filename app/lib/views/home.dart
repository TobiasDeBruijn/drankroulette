import 'dart:developer';

import 'package:drankroulette/components/display_game.dart';
import 'package:drankroulette/components/home/game_picker.dart';
import 'package:drankroulette/components/home/play_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => ComponentView(
                        component: DisplayGameComponent(game: game))
                    ));
          });
        })
      ],
    );
  }
}
