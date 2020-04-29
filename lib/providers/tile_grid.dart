import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/types/tuple.dart';

class TileGrid {
  final List<List<TileProvider>> _grid;
  final Set<Tuple<int, int>> _free;

  TileGrid.withSize(int gridSize)
      : assert(gridSize != null && gridSize > 0),
        _grid = List.generate(
          gridSize,
          (_) => List(gridSize),
          growable: false,
        ),
        _free = List.generate(
          gridSize * gridSize,
          (i) => Tuple(i ~/ gridSize, i % gridSize),
          growable: true,
        ).toSet();

  int get sideLength => _grid.length;

  int get flattenLength => _grid.length * _grid.length;

  List<Tuple<int, int>> get spawnableSpacesList => List.unmodifiable(_free);

  int get spawnableSpaces => _free.length;

  TileProvider get(int i, int j) => _grid[i][j];

  TileProvider getByTuple(Tuple<int, int> t) => _grid[t.a][t.b];

  Tuple<int, int> getRandomSpawnableSpace() {
    return spawnableSpacesList[Misc.rand.nextInt(_free.length)];
  }

  void set(int i, int j, TileProvider p, {bool allowReplace = true}) {
    if (_grid[i][j] == p) return;

    if (_grid[i][j] == null && !_free.remove(Tuple(i, j)))
      throw Exception("Grid is null at ($i, $j) but it's marked as filled");

    if (p == null && !_free.add(Tuple(i, j)))
      throw Exception("Trying to clear ($i, $j) but it's already empty");

    if (!allowReplace && p != null && _grid[i][j] != null)
      throw Exception("Tried to replace ${_grid[i][j]} with $p at ($i, $j)");

    _grid[i][j] = p;
  }

  void setAtTuple(
    Tuple<int, int> t,
    TileProvider p, {
    bool allowReplace = true,
  }) {
    this.set(t.a, t.b, p, allowReplace: allowReplace);
  }

  /*
  Exporters
   */

  Map<String, dynamic> toJSON() {
    return {
      'grid': _grid
          .map((line) => line.map((provider) => provider?.value ?? -1).toList())
          .toList(),
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
          this.log([
            "${tile.gridPos} can merge with",
            "${iNeighbor.gridPos}: ${tile.value}",
          ]);

          return false;
        }

        if (tile.compareValue(jNeighbor)) {
          this.log([
            "${tile.gridPos} can merge with",
            "${jNeighbor.gridPos}: ${tile.value}",
          ]);

          return false;
        }
      }
    }

    return true;
  }

  void log(Iterable<String> messages) {
    Logger.log<TileGrid>(messages.join());
  }
}
