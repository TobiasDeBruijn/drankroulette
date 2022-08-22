import 'package:flutter/material.dart';

class ComponentView<T extends Widget> extends StatelessWidget {
  final T component;

  const ComponentView({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: component
    );
  }
}