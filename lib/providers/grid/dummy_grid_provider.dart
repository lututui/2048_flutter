import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/tile/dummy_tile_provider.dart';
import 'package:flutter_2048/providers/grid/base_grid_provider.dart';
import 'package:flutter_2048/util/dummy_tile_grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/immovable_tile.dart';
import 'package:provider/provider.dart';

class DummyGridProvider extends BaseGridProvider {
  @override
  DummyTileGrid grid;

  DummyGridProvider._(this.grid) : super();

  factory DummyGridProvider(BuildContext context) {
    return DummyGridProvider._(
      DummyTileGrid(DimensionsProvider.of(context, listen: false).gridSize),
    );
  }

  factory DummyGridProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<DummyGridProvider>(context, listen: listen);
  }

  @override
  void spawnAt(Tuple<int, int> pos, {int value}) {
    grid.setAtTuple(
      pos,
      DummyTileProvider(pos, value: value),
      allowReplace: false,
    );
    tiles.add(ImmovableTile(grid.getByTuple(pos)),
    );
  }
}
