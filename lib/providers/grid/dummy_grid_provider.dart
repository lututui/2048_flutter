import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid/base_grid_provider.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/util/tile_grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/tile.dart';
import 'package:provider/provider.dart';

class DummyGridProvider extends BaseGridProvider {
  DummyGridProvider._(TileGrid grid) : super(grid);

  factory DummyGridProvider(BuildContext context) {
    return DummyGridProvider._(
      TileGrid(DimensionsProvider.of(context).gridSize),
    );
  }

  factory DummyGridProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<DummyGridProvider>(context, listen: listen);
  }

  @override
  void spawnAt(Tuple<int, int> pos, {int value}) {
    grid.setAtTuple(pos, TileProvider(pos, value: value), allowReplace: false);
    tiles.add(
      ChangeNotifierProvider.value(
        key: ObjectKey(grid.getByTuple(pos)),
        value: grid.getByTuple(pos),
        child: const Tile(),
      ),
    );
  }
}
