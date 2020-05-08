import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/widgets/tiles/unplaced_tile.dart';
import 'package:provider/provider.dart';

class MovableTile extends StatelessWidget {
  const MovableTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<DimensionsProvider, TileProvider>(
      builder: (context, dimensions, tileContext, _) {
        final double leftPos =
            tileContext.gridPos.b * dimensions.gapSize.width +
                tileContext.gridPos.b * dimensions.tileSize.width +
                dimensions.gapSize.width;
        final double topPos =
            tileContext.gridPos.a * dimensions.gapSize.height +
                tileContext.gridPos.a * dimensions.tileSize.height +
                dimensions.gapSize.height;

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
                borderWidth: dimensions.gapSize.width / 2.0,
                height: dimensions.tileSize.height,
                width: dimensions.tileSize.width,
                text: '${1 << tileContext.value}',
              );
            },
          ),
        );
      },
    );
  }
}
