import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/util/leaderboard.dart';
import 'package:flutter_2048/util/palette.dart';

class LeaderboardScreen extends StatelessWidget {
  final AsyncMemoizer<Leaderboard> _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Leaderboard>(
      future: _memoizer.runOnce(
        () => Leaderboard.fromJSON(
          DimensionsProvider.of(context, listen: false).gridSize,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Scaffold(
            backgroundColor: Palette.BOX_BACKGROUND,
            body: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Palette.getRandomTileColor(),
                ),
              ),
            ),
          );

        if (snapshot.hasError || !snapshot.hasData)
          throw Exception("Something went wrong");

        final Leaderboard leaderboard = snapshot.data;

        return Scaffold(
          backgroundColor: Palette.BOX_BACKGROUND,
          body: Center(
            child: Container(
              width: DimensionsProvider.of(context).gameSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Column(
                    children: const <Widget>[
                      const Text(
                        "Leaderboard",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: this.buildLeaderboardEntries(leaderboard),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildLeaderboardEntries(Leaderboard leaderboard) {
    final List<Widget> widgets = List();

    for (int i = 0; i < leaderboard.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${i + 1}",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                (leaderboard[i] == null) ? "---" : "${leaderboard[i]}",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }
}
