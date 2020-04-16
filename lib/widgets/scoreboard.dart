import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/score_text.dart';
import 'package:provider/provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Provider.of<DimensionsProvider>(context).gapSize.width * 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const BorderedBox(
            child: const Text(
              "Score",
              style: const TextStyle(
                fontFamily: Fonts.RIGHTEOUS_FAMILY,
                fontSize: 20,
              ),
            ),
            backgroundColor: Palette.BOX_BACKGROUND,
            borderColor: Palette.BOX_BORDER,
            alignment: Alignment.centerLeft,
          ),
          const BorderedBox(
            child: const ScoreText(),
            backgroundColor: Palette.BOX_BACKGROUND,
            borderColor: Palette.BOX_BORDER,
          ),
        ],
      ),
    );
  }
}
