import 'package:flutter/material.dart';

class ScoreText extends StatelessWidget {
  final int score;

  ScoreText({Key key, @required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "$score",
      maxLines: 1,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
    );
  }
}
