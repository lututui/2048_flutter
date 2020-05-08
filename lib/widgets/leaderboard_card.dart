import 'package:flutter/material.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/generic/animated_gradient_border.dart';

class LeaderboardCard extends StatelessWidget {
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

  TextStyle get textStyle => TextStyle(fontSize: this.highScore ? 25.0 : 15.0);

  EdgeInsets get outerPadding => EdgeInsets.all(this.highScore ? 8.0 : 4.0);

  EdgeInsets get innerPadding => EdgeInsets.all(this.highScore ? 16.0 : 8.0);

  Radius get borderRadius => Radius.circular(this.highScore ? 16.0 : 8.0);

  double get heightRatio => this.highScore ? 1.4 / 5 : 0.8 / 5;

  Widget buildCardContainer({BoxConstraints constraints, Widget child}) {
    if (this.highScore) {
      return AnimatedGradientBorder(
        width: constraints.averageWidth,
        height: this.heightRatio * constraints.averageWidth,
        borderWidth: 10.0,
        borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
        gradientStart: Palette.GOLDEN_GRADIENT,
        gradientEnd: Palette.SILVER_GRADIENT,
        child: child,
      );
    }

    return SizedBox(
      width: constraints.averageWidth,
      height: this.heightRatio * constraints.averageWidth,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.outerPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return buildCardContainer(
            constraints: constraints,
            child: Container(
              padding: this.innerPadding,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.all(this.borderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(this.position, style: this.textStyle),
                  Text(this.score, style: this.textStyle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
