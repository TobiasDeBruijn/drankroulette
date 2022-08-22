import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:drankroulette/data/game.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';

class GamePickerComponent extends StatefulWidget {
  GamePickerComponent({Key? key}) : super(key: key);

  List<Game> _games = [];
  final _scrollController = FixedExtentScrollController();
  final _random = Random();

  void startScrolling(Function(Game) onScrollDone) {
    int randomIdx = _random.nextInt(_games.length - 1);
    int randomMultiplier = 300 + _random.nextInt(500 - 300);

    int position = (randomIdx + 1) * randomMultiplier;
    dev.log("Scrolling to game at random position $position");

    const int duration = 10;
    _scrollController.animateToItem(
        position,
        duration: const Duration(seconds: duration),
        curve: Curves.decelerate
    );

    Timer(const Duration(seconds: duration + 2), () {
      onScrollDone(_games[randomIdx]);
    });
  }

  @override
  State<GamePickerComponent> createState() => _GamePickerState();
}

class _GamePickerState extends State<GamePickerComponent> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        child: _isLoaded ? _getIsLoaded() : _getIsLoading()
      )
    );
  }

  Widget _getIsLoading() {
    return const Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator()
    );
  }

  Widget _getIsLoaded() {
    return SizedBox(
      height: 300,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 28,
        controller: widget._scrollController,
        diameterRatio: 1.2,
        physics: const NeverScrollableScrollPhysics(),
        childDelegate: ListWheelChildLoopingListDelegate(
          children: _getGamesUi(),
        ),
      ),
    );
  }

  List<Widget> _getGamesUi() {
    return widget._games.map((e) => Text(
      e.name,
      style: getDefaultTextStyle(),
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  void loadGames() async {
    Result<List<Game>> listGamesResult = await GameApi.listGames();

    if (!mounted) {
      return;
    }

    if (!listGamesResult.handleIfNotOk(context)) {
      return;
    }

    setState(() {
      dev.log('Available games loaded');
      _isLoaded = true;
      widget._games = listGamesResult.value!;
    });
  }
}