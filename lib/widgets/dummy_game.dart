import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/tiles/immovable_tile.dart';

class DummyGame extends StatelessWidget {
  final List<List<Widget>> tiles;

  DummyGame.withSizes(BuildContext context, int sizes, {Key key})
      : tiles = List.generate(sizes, (_) => List(), growable: false),
        super(key: key);

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
        borderColor: Palette.getTileBorder(value),
        color: Palette.getTileColor(value),
        gridPos: pickedSpawnedPos,
        value: 1 << value,
      );

      this.tiles[index].add(newTile);

      assert(!spawningPosList.contains(pickedSpawnedPos));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);
    final int index = SizeOptions.getSizeIndexBySideLength(dimensions.gridSize);

    if (tiles[index].isEmpty) {
      this.spawnTiles(index, dimensions.gridSize);
    }

    final Size predictedMaxSize = DimensionsProvider.calculateSizes(
      MediaQuery.of(context).size,
      SizeOptions.SIZES.first.sideLength,
    )["game"]
        .scale(factor: 0.7);

    return Container(
      width: predictedMaxSize.width,
      height: predictedMaxSize.height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BorderedBox(
            backgroundColor: Palette.BOX_BACKGROUND,
            borderColor: Palette.BOX_BORDER,
            width: dimensions.gameSize.width,
            height: dimensions.gameSize.height,
            borderWidth: dimensions.gapSize.width / 2,
            child: Stack(
              overflow: Overflow.visible,
              children: tiles[index],
            ),
          ),
        ),
      ),
    );
  }
}
