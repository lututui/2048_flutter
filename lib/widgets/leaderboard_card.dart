import 'package:flutter/material.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/generic/animated_gradient_border.dart';

/// A [Card]-like widget used in [LeaderboardScreen]
class LeaderboardCard extends StatelessWidget {
  /// Creates a new leaderboard card
  factory LeaderboardCard({
    @required int position,
    int score,
    bool highScore,
    Key key,
  }) {
    assert(position != null);

    return LeaderboardCard._(
      key: key,
      position: position.toString(),
      score: score?.toString() ?? '---',
      highScore: highScore,
    );
  }

  const LeaderboardCard._({
    @required this.position,
    @required this.score,
    this.highScore = false,
    Key key,
  }) : super(key: key);

  /// The position of this card in the leaderboard
  final String position;

  /// The score obtained
  final String score;

  /// Whether this score is the highest score
  final bool highScore;

  TextStyle get _textStyle => TextStyle(fontSize: highScore ? 25.0 : 15.0);

  EdgeInsets get _outerPadding => EdgeInsets.all(highScore ? 8.0 : 4.0);

  EdgeInsets get _innerPadding => EdgeInsets.all(highScore ? 16.0 : 8.0);

  Radius get _borderRadius => Radius.circular(highScore ? 16.0 : 8.0);

  double get _heightRatio => highScore ? 1.4 / 5 : 0.8 / 5;

  Widget _buildCardContainer({BoxConstraints constraints, Widget child}) {
    if (highScore) {
      return AnimatedGradientBorder(
        width: constraints.averageWidth,
        height: _heightRatio * constraints.averageWidth,
        borderWidth: 10.0,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        gradientStart: Palette.goldenGradient,
        gradientEnd: Palette.silverGradient,
        child: child,
      );
    }

    return SizedBox(
      width: constraints.averageWidth,
      height: _heightRatio * constraints.averageWidth,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _outerPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildCardContainer(
            constraints: constraints,
            child: Container(
              padding: _innerPadding,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.all(_borderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(position, style: _textStyle),
                  Text(score, style: _textStyle),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
