import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TextPopupView extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color iconColor;

  const TextPopupView({Key? key, required this.text, this.iconData = MdiIcons.alertCircle, this.iconColor = Colors.redAccent}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 40
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: getDefaultTextStyle()
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  )
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Ok",
                style: getDefaultTextStyle(),
              ),
            ),
          )
        ],
      )
    );
  }
}