import 'package:flutter/material.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/mixins/game_ref_holder.dart';

class Scoreboard extends StatefulWidget with IGameRefHolder<Game2048> {
  @override
  final Game2048 gameRef;

  Scoreboard(this.gameRef);

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  int get value => this.widget.gameRef.score.value;

  ValueNotifier get score => this.widget.gameRef.score;

  void onScoreChange() {
    this.setState(() {});
  }

  @override
  void initState() {
    super.initState();

    this.score.addListener(this.onScoreChange);
  }


  @override
  void dispose() {
    super.dispose();

    this.score.removeListener(this.onScoreChange);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: this.widget.gameRef.gameBox.y -
          8.0 * this.widget.gameRef.dimensions.gapSize.height,
      left: this.widget.gameRef.gameBox.x,
      child: Container(
        padding: EdgeInsets.only(bottom: 2.0),
        width: this.widget.gameRef.dimensions.gameSize.width,
        height: 6.0 * this.widget.gameRef.dimensions.gapSize.height,
        color: Colors.cyanAccent,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            "${this.value}",
            maxLines: 1,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
