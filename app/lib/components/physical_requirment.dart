import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PhysicalRequirmentComponent extends StatelessWidget {
  final PhysicalRequirment physicalRequirment;

  const PhysicalRequirmentComponent({Key? key, required this.physicalRequirment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PhysicalRequirmentType? type = fromServerString(physicalRequirment.object);
    IconData iconData;
    if(type == null) {
      iconData = MdiIcons.helpCircleOutline;
    } else {
      iconData = getPhysicalRequirmentIcon(type);
    }

    return Column(
      children: [
        Icon(iconData),
        Text(
          physicalRequirment.count.toString(),
          style: GoogleFonts.oxygen(fontSize: 16),
        ),
      ],
    );
  }
}