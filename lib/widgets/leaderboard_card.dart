import 'package:flutter/material.dart';
import 'package:flutter_2048/widgets/generic/animated_gradient_border.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/util/palette.dart';

class LeaderboardCard extends StatelessWidget {
  static const BorderRadiusGeometry _SHAPE = const BorderRadius.all(
    const Radius.circular(16.0),
  );

  final String position;
  final String score;
  final bool highScore;

  const LeaderboardCard._({
    Key key,
    @required this.position,
    @required this.score,
    this.highScore = false,
  }) : super(key: key);

  factory LeaderboardCard({
    Key key,
    @required int position,
    int score,
    bool highScore,
  }) {
    assert(position != null);

    return LeaderboardCard._(
      key: key,
      position: position.toString(),
      score: score?.toString() ?? "---",
      highScore: highScore,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.highScore) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = Lists.takeAverage(
              [constraints.maxWidth, constraints.minWidth],
            );
            final double height = 1.4 * width / 5;

            return AnimatedGradientBorder(
              width: width,
              height: height,
              borderWidth: 10.0,
              borderRadius: _SHAPE,
              gradientStart: Palette.GOLDEN_GRADIENT,
              gradientEnd: Palette.SILVER_GRADIENT,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: _SHAPE,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      this.position,
                      style: const TextStyle(fontSize: 25),
                    ),
                    Text(
                      this.score,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = Lists.takeAverage(
            [constraints.maxWidth, constraints.minWidth],
          );
          final double height = 0.8 * width / 5;

          return Container(
            constraints: BoxConstraints.tightFor(
              width: width,
              height: height,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: _SHAPE,
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  this.position,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  this.score,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
