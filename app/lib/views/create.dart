import 'dart:collection';

import 'package:drankroulette/components/create/physical_requirment.dart';
import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateView extends StatefulWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  GlobalKey<FormState> _createGameFK = GlobalKey();

  // K: The name of the physical requirment as known on the server. E.g. 'CardSet'
  // V: The associated GlobalKey
  HashMap<String, GlobalKey<PhysicalRequirmentInputState>> _phyRequirmentKeys = HashMap();

  TextEditingController _gameOutlineTEC = TextEditingController();
  TextEditingController _gameRulesTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 8,
          ),
          Text(
            "Game toevoegen",
            style: GoogleFonts.oxygen(fontSize: 26),
          ),
          const SizedBox(
            height: 8
          ),
          Form(
            key: _createGameFK,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _getOutlineTextField(),
                  _getRulesTextField(),
                  _getPhysicalRequirmentsInput(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getOutlineTextField() {
    return TextField(
      controller: _gameOutlineTEC,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        label: Text(
          "Korte omscrhijving",
          style: GoogleFonts.oxygen(fontSize: 22),
        )
      ),
      maxLength: 48,
    );
  }

  Widget _getRulesTextField() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: TextField(
        controller: _gameRulesTEC,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Text(
            "Spelregels",
            style: GoogleFonts.oxygen(fontSize: 22),
          )
        ),
        expands: false,
        maxLines: null,
      ),
    );
  }

  Widget _getPhysicalRequirmentsInput() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: [
        _getSinglePhysicalRequirment("CardSet", PhysicalRequirmentType.cardSet),
        _getSinglePhysicalRequirment("Dice", PhysicalRequirmentType.dice),
        _getSinglePhysicalRequirment("Scoreboard", PhysicalRequirmentType.scoreboard),
        _getSinglePhysicalRequirment("RedCups", PhysicalRequirmentType.redCups),
      ],
    );
  }

  Widget _getSinglePhysicalRequirment(String name, PhysicalRequirmentType physicalRequirmentType) {
    GlobalKey<PhysicalRequirmentInputState> globalKey = GlobalKey();
    _phyRequirmentKeys[name] = globalKey;

    return PhysicalRequirmentInputComponent(key: globalKey, physicalRequirmentType: physicalRequirmentType);
  }
}