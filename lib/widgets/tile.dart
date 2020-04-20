import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/fixed_width_text.dart';
import 'package:provider/provider.dart';

class Tile extends StatelessWidget {
  const Tile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tileContext = Provider.of<TileProvider>(context);
    final dimensions = Provider.of<DimensionsProvider>(context);

    final double leftPos = tileContext.gridPos.b * dimensions.gapSize.width +
        tileContext.gridPos.b * dimensions.tileSize.width +
        dimensions.gapSize.width;
    final double topPos = tileContext.gridPos.a * dimensions.gapSize.height +
        tileContext.gridPos.a * dimensions.tileSize.height +
        dimensions.gapSize.height;

    final Color tileColor = Palette.getTileColor(tileContext.value);
    final Color tileBorder = Palette.getTileBorder(tileContext.value);

    return AnimatedPositioned(
      onEnd: () {
        final GridProvider grid = Provider.of<GridProvider>(
          context,
          listen: false,
        );
        final TileProvider tile = Provider.of<TileProvider>(
          context,
          listen: false,
        );

        tile.onMoveEnd();
        grid.onMoveEnd(tile);
      },
      duration: const Duration(milliseconds: 100),
      left: leftPos,
      top: topPos,
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          border: Border.fromBorderSide(
            BorderSide(
              color: tileBorder,
              width: dimensions.gapSize.width / 2,
            ),
          ),
        ),
        height: dimensions.tileSize.height,
        width: dimensions.tileSize.width,
        alignment: Alignment.center,
        child: FixedWidthText(
          text: "${1 << tileContext.value}",
          width: dimensions.tileSize.width,
        ),
      ),
    );
  }
}
