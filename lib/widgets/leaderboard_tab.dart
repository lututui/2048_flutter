import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/leaderboard.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/generic/future_widget.dart';
import 'package:flutter_2048/widgets/leaderboard_card.dart';

class LeaderboardTab extends StatelessWidget {
  final int gridSize;

  LeaderboardTab({Key key, this.gridSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureWidget<Leaderboard>(
      computation: () => Leaderboard.fromJSON(this.gridSize),
      loadingChild: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(
            Palette.PROGRESS_INDICATOR_COLOR,
          ),
        ),
      ),
      onError: (error) => throw Exception("Something went wrong: $error"),
      builder: (context, snapshot) {
        final Leaderboard leaderboard = snapshot.data;

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Position",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Palette.TAB_BAR_THEME_COLOR,
                    ),
                  ),
                  const Text(
                    "Score",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Palette.TAB_BAR_THEME_COLOR,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    return LeaderboardCard(
                      position: index + 1,
                      score: leaderboard[index],
                      highScore: index == 0 && leaderboard[index] != null,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
