import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:provider/provider.dart';

class ScoreText extends StatelessWidget {
  const ScoreText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${Provider.of<ScoreProvider>(context).value}",
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
