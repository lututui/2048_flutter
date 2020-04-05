import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/widgets/pause.dart';
import 'package:flutter_2048/widgets/scoreboard.dart';

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
    this.gameInstance.resize(MediaQuery.of(context).size);

    return Scaffold(
      body: WillPopScope(
        child: Stack(
          textDirection: TextDirection.ltr,
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: <Widget>[
            this.gameInstance.widget,
            Scoreboard(this.gameInstance),
          ],
        ),
        onWillPop: () => this.confirmReturn(context),
      ),
    );
  }

  Future<bool> confirmReturn(BuildContext context) {
    this.gameInstance.pause();

    return showDialog<String>(
      context: context,
      builder: (_) => const PauseMenu(),
    ).then((String v) {
      // Dismissed or resumed
      if (v == null) {
        this.gameInstance.unpause();
        return Future.value(false);
      }

      this.gameInstance.reset();

      return Future.value(v == 'exit');
    });
  }
}
