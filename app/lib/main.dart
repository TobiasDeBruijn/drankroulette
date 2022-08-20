import 'package:drankroulette/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MaterialApp(
    title: 'DrankRoulette',
    home: SplashScreenView()
  ));
}

TextStyle getDefaultTextStyle() {
  return GoogleFonts.oxygen(fontSize: 20);
}