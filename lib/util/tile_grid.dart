import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';

class TileGrid {
  final List<List<TileProvider>> _grid;
  final Set<Tuple<int, int>> _free;

  /*
  Constructors
   */

  const TileGrid._(this._grid, this._free);

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
  Getters
   */

  int get sideLength => _grid.length;

  List<Tuple<int, int>> get spawnableSpacesList => List.unmodifiable(_free);

  int get spawnableSpaces => _free.length;

  TileProvider get(int i, int j) => _grid[i][j];

  TileProvider getByTuple(Tuple<int, int> t) => _grid[t.a][t.b];

  Tuple<int, int> getRandomSpawnableSpace() {
    return spawnableSpacesList[Data.rand.nextInt(_free.length)];
  }

  /*
  Setters
   */

  void set(int i, int j, TileProvider p, {bool allowReplace = true}) {
    if (_grid[i][j] == p) return;

    if (_grid[i][j] == null && !_free.remove(Tuple(i, j)))
      throw Exception("Tile grid sanity violated");

    if (p == null && !_free.add(Tuple(i, j)))
      throw Exception("Tile grid sanity violated");

    if (!allowReplace && p != null && _grid[i][j] != null)
      throw Exception("Tile grid tried to replace");

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
    final List<List<int>> convertedGrid = _grid.map<List<int>>((line) {
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
