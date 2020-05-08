import 'package:flutter/material.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/leaderboard_tab.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({Key key}) : super(key: key);

  final List<Tab> leaderboardTabs = SizeOptions.sizes
      .map<Tab>((size) => Tab(text: size.description))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: DefaultTabController(
        length: SizeOptions.sizes.length,
        initialIndex: 1,
        child: Column(
          children: <Widget>[
            TabBar(
              tabs: leaderboardTabs,
              labelColor: Theme.of(context).colorScheme.onSurface,
            ),
            Expanded(
              child: TabBarView(
                children: SizeOptions.sizes
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
