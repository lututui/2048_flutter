import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile/tile_provider.dart';
import 'package:flutter_2048/util/grid.dart';
import 'package:flutter_2048/util/tuple.dart';

class TileGrid extends Grid<TileProvider> {
  TileGrid._(
    List<List<TileProvider>> grid,
    Set<Tuple<int, int>> free,
  ) : super(grid, free);

  factory TileGrid(int gridSize) {
    return TileGrid._(
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

  /*
  Exporters
   */

  Map<String, dynamic> toJSON() {
    final List<List<int>> convertedGrid = grid.map<List<int>>((line) {
      return line.map<int>((provider) {
        return provider?.value ?? -1;
      }).toList();
    }).toList();

    return {
      "grid": convertedGrid,
    };
  }

  /*
  Logic
   */

  bool testGameOver() {
    for (int i = 0; i < sideLength; i++) {
      for (int j = 0; j < sideLength; j++) {
        final bool skipI = i + 1 >= sideLength;
        final bool skipJ = j + 1 >= sideLength;

        if (skipI && skipJ) continue;

        final TileProvider tile = get(i, j);
        final TileProvider iNeighbor = (skipI) ? null : get(i + 1, j);
        final TileProvider jNeighbor = (skipJ) ? null : get(i, j + 1);

        if (tile.compareValue(iNeighbor)) {
          Logger.log<TileGrid>(
            "${tile.gridPos} can merge with ${iNeighbor.gridPos}: ${tile.value}",
          );

          return false;
        }

        if (tile.compareValue(jNeighbor)) {
          Logger.log<TileGrid>(
            "${tile.gridPos} can merge with ${jNeighbor.gridPos}: ${tile.value}",
          );

          return false;
        }
      }
    }

    return true;
  }
}
