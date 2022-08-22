import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayGameComponent extends StatelessWidget {
  final Game game;

  const DisplayGameComponent({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.name,
            style: GoogleFonts.oxygen(fontSize: 26),
          ),
          Text(
            game.outline,
            style: getDefaultTextStyle(),
          ),
          const Divider(thickness: 3),
          Text(
            game.gameRules,
            style: getDefaultTextStyle(),
          )
        ],
      ),
    );
  }
}