import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/tiles/immovable_tile.dart';
import 'package:flutter_2048/widgets/tiles/unplaced_tile.dart';
import 'package:provider/provider.dart';

/// An [UnplacedTile] positioned in a [Stack], but cannot be moved, unlike
/// [ImmovableTile].
///
/// Used by [GameGrid].
///
/// The position and value of this widget is provided by a [TileProvider] placed
/// somewhere above this widget in the widget tree. This widget will animate to
/// a new position when [TileProvider.gridPos] changes
class MovableTile extends StatelessWidget {
  /// Creates a new movable tile widget
  const MovableTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<DimensionsProvider, TileProvider>(
      builder: (context, dimensions, tileContext, _) {
        final double gapSize = dimensions.gapSize;
        final double tileSize = dimensions.tileSize;

        final double leftPos = tileContext.gridPos.b * gapSize +
            tileContext.gridPos.b * tileSize +
            gapSize;
        final double topPos = tileContext.gridPos.a * gapSize +
            tileContext.gridPos.a * tileSize +
            gapSize;

        return AnimatedPositioned(
          onEnd: () {
            final TileProvider tile = TileProvider.of(context);

            tile.onMoveEnd();
            GridProvider.of(context).onMoveEnd(tile);
          },
          duration: const Duration(milliseconds: 100),
          left: leftPos,
          top: topPos,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return UnplacedTile(
                color: settings.palette.getTileColor(tileContext.value),
                borderSize: gapSize / 2.0,
                size: tileSize,
                text: '${1 << tileContext.value}',
              );
            },
          ),
        );
      },
    );
  }
}
