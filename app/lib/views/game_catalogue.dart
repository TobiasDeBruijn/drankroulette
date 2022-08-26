import 'dart:developer';

import 'package:drankroulette/components/physical_requirment.dart';
import 'package:drankroulette/data/game.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/main.dart';
import 'package:drankroulette/views/component.dart';
import 'package:drankroulette/views/text_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/display_game.dart';

class GameCatalogueView extends StatefulWidget {
  const GameCatalogueView({Key? key}) : super(key: key);

  @override
  State<GameCatalogueView> createState() => _GameCatalogueState();
}

class _GameCatalogueState extends State<GameCatalogueView> {

  List<Game> _games = [];
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _getIsLoading(context) : _getIsLoaded(context);
  }

  Widget _getIsLoading(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
      ),
    );
  }

  Widget _getIsLoaded(BuildContext context) {
    log("Games ui is building: ${_games.length}");
    List<Widget> children = _games.map((e) => _getGameUi(e)).toList();

    final Size size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / (PhysicalRequirmentType.values.length / 1.5);
    final double itemWidth = size.width / 2;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      children: children,
    );
  }

  Widget _getGameUi(Game game) {
    log("Building game!");

    List<PhysicalRequirment> phyRequirments = game.physicalRequirments;
    phyRequirments.sort((a, b) => b.count.compareTo(a.count));

    return InkWell(
      onTap: () => {
        animatedPageTransition(
            context: context,
            page: ComponentView(component: DisplayGameComponent(game: game)),
            direction: AnimateDirection.up
        )
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                game.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.oxygen(fontWeight: FontWeight.bold, fontSize: 22)
              ),
              Text(
                game.outline,
                style: getDefaultTextStyle(),
              ),
              const SizedBox(
                height: 5
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                children: phyRequirments
                  .map((e) => PhysicalRequirmentComponent(physicalRequirment: e))
                  .toList(),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadGames();
  }

  void loadGames() async {
    setState(() {
      _isLoading = true;
    });

    Result<List<Game>> gamesResult = await GameApi.listGames();

    setState(() {
      _isLoading = false;
    });

    if(!mounted) {
      return;
    }

    if(!gamesResult.isOk) {
      showDialog(context: context, builder: (builder) => const TextPopupView(
        text: "Er is iets verkeerd gegaan."
      ));
      return;
    }

    setState(() {
      _games = gamesResult.value!;
    });
  }
}