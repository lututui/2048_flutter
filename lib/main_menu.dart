import 'package:flutter/material.dart';
import 'package:flutter_2048/game_2048.dart';

class MainMenu extends StatelessWidget {
  final Game2048 gameInstance = Game2048();

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
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: buildGame),
                ),
                color: Colors.transparent,
                borderSide: const BorderSide(style: BorderStyle.none),
                child: const Text(
                  "New Game",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 16.0,
                    fontFamily: "Righteous",
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGame(BuildContext context) => this.gameInstance.widget;
}
