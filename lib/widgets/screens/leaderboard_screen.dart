import 'package:flutter/material.dart';
import 'package:flutter_2048/types/size_options.dart';

/// The leaderboard screen widget
class LeaderboardScreen extends StatelessWidget {
  /// Creates a new leaderboard screen widget
  const LeaderboardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget tabBar = TabBar(
      tabs: SizeOption.tabs,
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
      length: SizeOption.amount,
      initialIndex: 1,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            appBar.preferredSize.width,
            appBar.preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          child: appBar,
        ),
        body: TabBarView(children: SizeOption.tabViews),
      ),
    );
  }
}
