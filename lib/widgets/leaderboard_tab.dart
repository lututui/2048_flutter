import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/leaderboard.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/generic/future_widget.dart';
import 'package:flutter_2048/widgets/leaderboard_card.dart';

/// A widget to be shown with [TabBarView] in [LeaderboardScreen]
class LeaderboardTab extends StatelessWidget {
  /// Creates a new leaderboard tab for the given grid size
  const LeaderboardTab(this._gridSize, {Key key}) : super(key: key);

  final int _gridSize;

  @override
  Widget build(BuildContext context) {
    return FutureWidget<Leaderboard>(
      computation: () => Leaderboard.fromJSON(_gridSize),
      loadingChild: Misc.buildLoadingWidget,
      builder: (context, snapshot) {
        final Leaderboard leaderboard = snapshot.data;

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Position',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text('Score', style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
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
