import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/util/palette.dart';
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

        final Color tileColor = Palette.getTileColor(tileContext.value);
        final Color tileBorder = Palette.getTileBorder(tileContext.value);

        return AnimatedPositioned(
          onEnd: () {
            final TileProvider tile = TileProvider.of(context, listen: false);

            tile.onMoveEnd();
            GridProvider.of(context, listen: false).onMoveEnd(tile);
          },
          duration: const Duration(milliseconds: 100),
          left: leftPos,
          top: topPos,
          child: UnplacedTile(
            color: tileColor,
            borderColor: tileBorder,
            borderWidth: dimensions.gapSize.width / 2.0,
            height: dimensions.tileSize.height,
            width: dimensions.tileSize.width,
            text: "${1 << tileContext.value}",
          ),
        );
      },
    );
  }
}
