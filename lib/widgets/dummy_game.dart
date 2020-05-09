import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/tiles/immovable_tile.dart';
import 'package:provider/provider.dart';

class DummyGame extends StatelessWidget {
  DummyGame.withSizes(int sizes, {Key key})
      : tiles = List.generate(sizes, (_) => [], growable: false),
        super(key: key);

  final List<List<Widget>> tiles;

  void spawnTiles(int index, int sideLength) {
    final int flatLength = sideLength * sideLength;
    final int spawnAmount = Misc.rand.nextIntRanged(
      min: sideLength - 1,
      max: flatLength - sideLength,
    );

    final List<Tuple<int, int>> spawningPosList = List.generate(
      flatLength,
      (i) => Tuple(i ~/ sideLength, i % sideLength),
    );

    for (int i = 0; i < spawnAmount; i++) {
      final Tuple<int, int> pickedSpawnedPos = Misc.rand.pick(
        spawningPosList,
        remove: true,
      );
      final int value = Misc.rand.nextInt(sideLength);

      final ImmovableTile newTile = ImmovableTile(
        gridPos: pickedSpawnedPos,
        value: value,
      );

      tiles[index].add(newTile);

      assert(!spawningPosList.contains(pickedSpawnedPos));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size predictedMaxSize = DimensionsProvider.calculateSizes(
      MediaQuery.of(context).size,
      SizeOptions.sizes.first.sideLength,
    )['game']
        .scale(factor: 0.7);

    return Container(
      width: predictedMaxSize.width,
      height: predictedMaxSize.height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Consumer<DimensionsProvider>(
            builder: (context, dimensions, _) {
              final int index = SizeOptions.getSizeIndexBySideLength(
                dimensions.gridSize,
              );

              if (tiles[index].isEmpty) {
                spawnTiles(index, dimensions.gridSize);
              }

              return BorderedBox(
                width: dimensions.gameSize.width,
                height: dimensions.gameSize.height,
                borderWidth: dimensions.gapSize.width * (index + 1.0),
                child: Stack(
                  overflow: Overflow.visible,
                  children: tiles[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
