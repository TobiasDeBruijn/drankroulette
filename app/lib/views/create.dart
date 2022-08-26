import 'dart:collection';

import 'package:drankroulette/components/create/physical_requirment.dart';
import 'package:drankroulette/data/game.dart';
import 'package:drankroulette/data/proto/entity/game.pb.dart';
import 'package:drankroulette/data/result.dart';
import 'package:drankroulette/main.dart';
import 'package:drankroulette/views/text_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CreateView extends StatefulWidget {
  const CreateView({Key? key}) : super(key: key);

  @override
  State<CreateView> createState() => _CreateViewState();
}

class _CreateViewState extends State<CreateView> {
  final GlobalKey<FormState> _createGameFK = GlobalKey();

  // K: The name of the physical requirment as known on the server. E.g. 'CardSet'
  // V: The associated GlobalKey
  final HashMap<String, GlobalKey<PhysicalRequirmentInputState>> _phyRequirmentKeys = HashMap();

  final TextEditingController _gameOutlineTEC = TextEditingController();
  final TextEditingController _gameNameTEC = TextEditingController();
  final TextEditingController _gameRulesTEC = TextEditingController();

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 8,
              ),
              Text(
                "Spel toevoegen",
                style: GoogleFonts.oxygen(fontSize: 26),
              ),
              Form(
                key: _createGameFK,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _getNameTextField(),
                      _getOutlineTextField(),
                      _getRulesTextField(),
                      Text(
                        "Vereisten",
                        style: GoogleFonts.oxygen(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      _getPhysicalRequirmentsInput(),
                    ],
                  ),
                ),
              ),
              _getSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getOutlineTextField() {
    return TextFormField(
      controller: _gameOutlineTEC,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        label: Text(
          "Korte omscrhijving",
          style: GoogleFonts.oxygen(fontSize: 22),
        )
      ),
      maxLength: 48,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Dit veld is vereist';
        }

        return null;
      },
    );
  }

  Widget _getNameTextField() {
    return TextFormField(
      controller: _gameNameTEC,
      decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Text(
            "Spelnaam",
            style: GoogleFonts.oxygen(fontSize: 22),
          )
      ),
      maxLength: 32,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if(value == null || value.isEmpty) {
          return 'Dit veld is vereist';
        }

        return null;
      },
    );
  }

  Widget _getRulesTextField() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: TextFormField(
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'Dit veld is vereist';
          }

          return null;
        },
      ),
    );
  }

  Widget _getPhysicalRequirmentsInput() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
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

  Widget _getSaveButton() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        )
      ),
      child: _isSaving ?
      const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
      )
      : Text(
        "Opslaan",
        style: getDefaultTextStyle(),
      ),
      onPressed: () async {
        if(!_createGameFK.currentState!.validate()) {
          return;
        }

        setState(() {
          _isSaving = true;
        });

        String name = _gameRulesTEC.text;
        String outline = _gameOutlineTEC.text;
        String gameRules = _gameRulesTEC.text;

        List<PhysicalRequirment> phyRequirments = [];
        for(MapEntry<String, GlobalKey<PhysicalRequirmentInputState>> entry in _phyRequirmentKeys.entries) {
          phyRequirments.add(PhysicalRequirment(
            object: entry.key,
            count: entry.value.currentState!.itemCount,
          ));
        }

        Game game = Game(
          name: name,
          outline: outline,
          gameRules: gameRules,
          physicalRequirments: phyRequirments,
        );

        Result<String> createResult = await GameApi.createGame(game);
        if(!createResult.isOk) {
          showDialog(context: context, builder: (builder) => const TextPopupView(
            text: "Het is niet gelukt om het spel toe te voegen. Er is iets verkeerd gegaan."
          ));
          return;
        }

        // TODO do we want to open the game after creating it?
        showDialog(context: context, builder: (builder) => const TextPopupView(
          text: "Het spel is aangemaakt!",
          iconData: MdiIcons.check,
          iconColor: Colors.green,
        ));

        // Refresh the game cache
        await GameApi.listGames(ignoreCache: true);

        setState(() {
          _isSaving = false;
        });
      },
    );
  }
}