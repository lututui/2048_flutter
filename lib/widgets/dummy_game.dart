import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tile_grid.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:provider/provider.dart';

class DummyGame extends StatelessWidget {
  final GridProvider dummyGridProvider;

  const DummyGame({Key key, this.dummyGridProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);
    final Size predictedMaxSize = DimensionsProvider.calculateSizes(
          MediaQuery.of(context).size,
          SizeOptions.SIZES.first.sideLength,
        )["game"] *
        0.7;
    bool needsSpawn = false;

    if (dummyGridProvider.grid == null) {
      dummyGridProvider.grid = TileGrid(dimensions.gridSize);
      dummyGridProvider.tiles.clear();

      needsSpawn = true;
    } else if (dummyGridProvider.grid.sideLength != dimensions.gridSize) {
      dummyGridProvider.grid = TileGrid(dimensions.gridSize);
      dummyGridProvider.tiles.clear();

      needsSpawn = true;
    }

    if (needsSpawn) {
      final int spawnTilesQuantity =
          3 + Data.rand.nextInt(dummyGridProvider.grid.flattenLength - 3);

      for (int i = 0; i < spawnTilesQuantity; i++) {
        dummyGridProvider.spawnAt(
          dummyGridProvider.grid.getRandomSpawnableSpace(),
          value: Data.rand.nextInt(spawnTilesQuantity),
        );
      }
    }

    return ChangeNotifierProvider.value(
      value: dummyGridProvider,
      child: Builder(
        builder: (context) {
          return Container(
            width: predictedMaxSize.width,
            height: predictedMaxSize.height,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: GameGrid(),
            ),
          );
        },
      ),
    );
  }
}
