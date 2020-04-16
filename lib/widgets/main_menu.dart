import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/util/fonts.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                onPressed: () => Navigator.of(context).pushNamed('/game4x4'),
                color: Colors.transparent,
                borderSide: const BorderSide(style: BorderStyle.none),
                child: const Text(
                  "New Game",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 16.0,
                    fontFamily: Fonts.RIGHTEOUS_FAMILY,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
