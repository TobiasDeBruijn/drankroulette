import 'package:drankroulette/components/create/physical_requirment.dart';
import 'package:drankroulette/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(const MaterialApp(
    title: 'DrankRoulette',
    home: SplashScreenView()
  ));
}

TextStyle getDefaultTextStyle() {
  return GoogleFonts.oxygen(fontSize: 20);
}

enum AnimateDirection {
  sideFromRight,
  sideFromLeft,
  up,
}

void animatedPageTransition({
  required BuildContext context,
  required Widget page,
  required AnimateDirection direction,
  Duration duration = const Duration(milliseconds: 500),
  bool replace = false,
}) {
  PageRouteBuilder pageRouteBuilder = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = _getOffsetForAnimateDirection(direction);

      const end = Offset.zero;
      const curve = Curves.decelerate;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );

  if(replace) {
    Navigator.of(context).pushReplacement(pageRouteBuilder);
  } else {
    Navigator.of(context).push(pageRouteBuilder);
  }
}

Offset _getOffsetForAnimateDirection(AnimateDirection direction) {
  switch(direction) {
    case AnimateDirection.sideFromRight:
      return const Offset(1, 0);
    case AnimateDirection.sideFromLeft:
      return const Offset(-1, 0);
    case AnimateDirection.up:
      return const Offset(0, 1);
  }
}

ButtonStyle getDebugButtonStyle() {
  return ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
      )
  );
}

enum PhysicalRequirmentType {
  cardSet,
  dice,
  scoreboard,
  redCups
}

PhysicalRequirmentType? fromServerString(String input) {
  switch(input) {
    case "CardSet": return PhysicalRequirmentType.cardSet;
    case "Dice": return PhysicalRequirmentType.dice;
    case "Scoreboard": return PhysicalRequirmentType.scoreboard;
    case "RedCups": return PhysicalRequirmentType.redCups;
    default: return null;
  }
}

IconData getPhysicalRequirmentIcon(PhysicalRequirmentType physicalRequirmentType) {
  switch(physicalRequirmentType) {
    case PhysicalRequirmentType.cardSet: return MdiIcons.cardsPlayingSpadeOutline;
    case PhysicalRequirmentType.dice: return MdiIcons.dice3Outline;
    case PhysicalRequirmentType.scoreboard: return MdiIcons.fileOutline;
    case PhysicalRequirmentType.redCups: return MdiIcons.beerOutline;
  }
}

String getPhysicalRequirmentDescription(PhysicalRequirmentType physicalRequirmentType) {
  switch (physicalRequirmentType) {
    case PhysicalRequirmentType.cardSet: return "Een volledig kaartspel";
    case PhysicalRequirmentType.dice: return "Een zes-zijdige dobbelsteen";
    case PhysicalRequirmentType.scoreboard: return "Een lijstje om scores op bij te houden";
    case PhysicalRequirmentType.redCups: return "Klassieke Amerikaanse Red Cups";
  }
}

String getPhysicalRequirmentUserFacingName(PhysicalRequirmentType physicalRequirmentType) {
  switch (physicalRequirmentType) {
    case PhysicalRequirmentType.cardSet: return "Kaartspel";
    case PhysicalRequirmentType.dice: return "Dobbelsteen";
    case PhysicalRequirmentType.scoreboard: return "Scorebord";
    case PhysicalRequirmentType.redCups: return "Red Cups";
  }
}