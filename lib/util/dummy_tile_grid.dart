import 'package:flutter_2048/providers/tile/dummy_tile_provider.dart';
import 'package:flutter_2048/util/grid.dart';
import 'package:flutter_2048/util/tuple.dart';

class DummyTileGrid extends Grid<DummyTileProvider> {
  DummyTileGrid._(
    List<List<DummyTileProvider>> grid,
    Set<Tuple<int, int>> free,
  ) : super(grid, free);

  factory DummyTileGrid(int gridSize) {
    return DummyTileGrid._(
      List.generate(
        gridSize,
        (_) => List(gridSize),
        growable: false,
      ),
      List.generate(
        gridSize * gridSize,
        (i) => Tuple(i ~/ gridSize, i % gridSize),
        growable: true,
      ).toSet(),
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    throw Exception("Dummy tile should never be saved");
  }
}
