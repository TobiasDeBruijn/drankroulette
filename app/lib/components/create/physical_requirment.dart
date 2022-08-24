import 'dart:ui';

import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PhysicalRequirmentInputComponent extends StatefulWidget {
  final PhysicalRequirmentType physicalRequirmentType;

  const PhysicalRequirmentInputComponent({Key? key, required this.physicalRequirmentType}) : super(key: key);

  @override
  State<PhysicalRequirmentInputComponent> createState() => PhysicalRequirmentInputState();
}

class PhysicalRequirmentInputState extends State<PhysicalRequirmentInputComponent> {
  int _itemCount = 0;
  int get itemCount => _itemCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onLongPress: () {
          showDialog(context: context, builder: (builder) => _PhysicalRequirmentInfoDialog(
              physicalRequirmentType: widget.physicalRequirmentType
          ));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                getPhysicalRequirmentIcon(widget.physicalRequirmentType),
                size: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 22,
                    icon: const Icon(MdiIcons.minusCircle),
                    onPressed: () {
                      if(_itemCount == 0) {
                        return;
                      }

                      setState(() {
                        _itemCount--;
                      });
                    },
                  ),
                  SizedBox(
                    width: 8,
                    child: Text(
                      _itemCount.toString(),
                      style: GoogleFonts.oxygen(fontSize: 16, fontFeatures: [ const FontFeature.tabularFigures() ]),
                    ),
                  ),
                  IconButton(
                    iconSize: 22,
                    icon: const Icon(MdiIcons.plusCircle),
                    onPressed: () {
                      if(_itemCount == 99) {
                        return;
                      }

                      setState(() {
                        _itemCount++;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PhysicalRequirmentInfoDialog extends StatelessWidget {
  final PhysicalRequirmentType physicalRequirmentType;

  const _PhysicalRequirmentInfoDialog({Key? key, required this.physicalRequirmentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getPhysicalRequirmentUserFacingName(physicalRequirmentType),
            style: GoogleFonts.oxygen(fontSize: 26),
          ),
          Text(
            getPhysicalRequirmentDescription(physicalRequirmentType),
            textAlign: TextAlign.center,
            style: getDefaultTextStyle(),
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
              "Ok",
              style: getDefaultTextStyle()
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ]
      )
    );
  }
}