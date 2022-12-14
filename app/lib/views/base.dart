import 'package:drankroulette/views/create.dart';
import 'package:drankroulette/views/game_catalogue.dart';
import 'package:drankroulette/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BaseView extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {

  int _bottomNavigationIdx = 0;

  final List<Widget> _pages = const [
    HomeView(),
    GameCatalogueView(),
    CreateView(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.grid),
      label: "Catalogus",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Create',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _pages[_bottomNavigationIdx],
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: Text (
        'DrankRoulette',
        style: GoogleFonts.oxygen(fontSize: 30),
      ),
    );
  }

  BottomNavigationBar _getBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _bottomNavigationIdx,
      onTap: (idx) => setState(() {
        _bottomNavigationIdx = idx;
      }),
      items: _bottomNavigationBarItems,
    );
  }
}