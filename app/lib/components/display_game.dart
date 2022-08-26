import 'package:drankroulette/components/physical_requirment.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DisplayGameComponent extends StatelessWidget {
  final Game game;

  const DisplayGameComponent({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          Card(
            elevation: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  game.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxygen(fontSize: 28),
                ),
              ),
            ),
          ),
          _getGamePhysicalRequirments(),
          Card(
            elevation: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Spelregels",
                      style: GoogleFonts.oxygen(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      game.gameRules,
                      style: getDefaultTextStyle(),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getGamePhysicalRequirments() {
    List<PhysicalRequirment> phyRequirments = game.physicalRequirments;
    phyRequirments.sort((a, b) => b.count.compareTo(a.count));

    List<Widget> physicalRequirmentIcons = phyRequirments
      .map((e) => PhysicalRequirmentComponent(physicalRequirment: e))
      .map((e) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
          child: e,
        ),
      ))
      .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: physicalRequirmentIcons,
    );
  }
}