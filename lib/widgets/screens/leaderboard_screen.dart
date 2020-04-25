import 'package:flutter/material.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/leaderboard_tab.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Tab> leaderboardTabs = SizeOptions.SIZES
      .map<Tab>(
        (size) => Tab(child: size.child),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
      ),
      body: DefaultTabController(
        length: SizeOptions.SIZES.length,
        initialIndex: 1,
        child: Column(
          children: <Widget>[
            TabBar(tabs: this.leaderboardTabs),
            Expanded(
              child: TabBarView(
                children: SizeOptions.SIZES
                    .map<Widget>(
                      (size) => LeaderboardTab(gridSize: size.sideLength),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
