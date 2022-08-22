import 'package:drankroulette/main.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {

  final Function pickGameFunction;

  const PlayButton({Key? key, required this.pickGameFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          )
        ),
        onPressed: () => pickGameFunction(),
        child: Text(
          "Play",
          style: getDefaultTextStyle(),
        ),
      )
    );
  }

}