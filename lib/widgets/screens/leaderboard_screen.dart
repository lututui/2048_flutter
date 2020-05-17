import 'package:flutter/material.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/leaderboard_tab.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key key}) : super(key: key);

  static final List<Tab> _tabsInTabBar = [
    for (final sizeOption in SizeOptions.sizes)
      Tab(text: sizeOption.description)
  ];

  static final List<LeaderboardTab> _tabBarView = [
    for (final sizeOption in SizeOptions.sizes)
      LeaderboardTab(gridSize: sizeOption.sideLength)
  ];

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
