import 'package:flutter/material.dart';
import 'package:flutter_2048/fonts.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/widgets/pause.dart';

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

  Widget buildGame(BuildContext context) {
    return WillPopScope(
      child: this.gameInstance.widget,
      onWillPop: () => this.confirmReturn(context),
    );
  }

  Future<bool> confirmReturn(BuildContext context) {
    this.gameInstance.swipeRecognizer.pause();

    return showDialog<String>(
      context: context,
      builder: (BuildContext innerContext) => const PauseMenu(),
    ).then((String v) {
      // Dismissed or resumed
      if (v == null) {
        this.gameInstance.swipeRecognizer.unpause();
        return Future.value(false);
      }

      this.gameInstance.reset();

      return Future.value(v == 'exit');
    });
  }
}
