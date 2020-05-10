import 'package:flutter/material.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/leaderboard_tab.dart';

class LeaderboardScreen extends StatelessWidget {
  LeaderboardScreen({Key key}) : super(key: key);

  final List<Tab> _tabsInTabBar = SizeOptions.sizes
      .map<Tab>((size) => Tab(text: size.description))
      .toList();

  final List<LeaderboardTab> _tabBarView = SizeOptions.sizes
      .map((size) => LeaderboardTab(gridSize: size.sideLength))
      .toList();

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget tabBar = TabBar(
      tabs: _tabsInTabBar,
      labelColor: Theme.of(context).colorScheme.onSurface,
    );

    final PreferredSizeWidget appBar = AppBar(
      title: const Text('Leaderboard'),
      primary: false,
      bottom: PreferredSize(
        preferredSize: tabBar.preferredSize,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: tabBar,
        ),
      ),
    );

    return DefaultTabController(
      length: SizeOptions.sizes.length,
      initialIndex: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            appBar.preferredSize.width,
            appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          child: appBar,
        ),
        body: TabBarView(children: _tabBarView),
      ),
    );
  }
}
