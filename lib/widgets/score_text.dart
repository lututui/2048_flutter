import 'package:flutter/material.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/mixins/game_ref_holder.dart';
import 'package:flutter_2048/util/fonts.dart';

class ScoreText extends StatefulWidget with IGameRefHolder<Game2048> {
  @override
  final Game2048 gameRef;

  ScoreText(this.gameRef);

  @override
  _ScoreTextState createState() => _ScoreTextState();
}

class _ScoreTextState extends State<ScoreText> {
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
    return Text(
      "${this.value}",
      maxLines: 1,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: Fonts.RIGHTEOUS_FAMILY,
        fontSize: 20,
      ),
    );
  }
}
