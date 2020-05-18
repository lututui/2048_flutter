import 'package:flutter/widgets.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/tiles/movable_tile.dart';
import 'package:provider/provider.dart';

class TileGrid {
  TileGrid(this._grid, this._free);

  TileGrid.empty(int gridSize)
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

  factory TileGrid.clone(TileGrid other) {
    final gridSize = other.sideLength;

    final copyGrid = List.generate(
      gridSize,
      (_) => List<TileProvider>(gridSize),
      growable: false,
    );

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        copyGrid[i][j] = other._grid[i][j]?.clone();
      }
    }

    return TileGrid(
      copyGrid,
      Set<Tuple<int, int>>.from(other._free),
    );
  }

  final List<List<TileProvider>> _grid;
  final Set<Tuple<int, int>> _free;

  void restore(TileGrid from, {List<Widget> tiles}) {
    assert(sideLength == from.sideLength);

    final Set<Tuple<int, int>> newFree = {};

    for (int i = 0; i < sideLength; i++) {
      for (int j = 0; j < sideLength; j++) {
        _grid[i][j] = from._grid[i][j];

        if (_grid[i][j] == null) {
          newFree.add(Tuple(i, j));
        }
      }
    }

    _free
      ..clear()
      ..addAll(newFree);

    if (tiles == null) return;

    tiles.clear();

    for (final entry in nonNullEntries) {
      tiles.add(
        ChangeNotifierProvider.value(
          key: ObjectKey(entry),
          value: entry,
          child: const MovableTile(),
        ),
      );
    }
  }

  int get sideLength => _grid.length;

  int get flattenLength => _grid.length * _grid.length;

  int get freeSpaces => _free.length;

  List<TileProvider> get nonNullEntries {
    final List<TileProvider> result = [];

    for (final line in _grid) {
      for (final p in line) {
        if (p == null) continue;

        result.add(p);
      }
    }

    return result;
  }

  TileProvider get(int i, int j) => _grid[i][j];

  TileProvider getByTuple(Tuple<int, int> t) => _grid[t.a][t.b];

  Tuple<int, int> getRandomSpawnableSpace() {
    return List.of(_free)[Misc.rand.nextInt(_free.length)];
  }

  void set(int i, int j, TileProvider p, {bool allowReplace = true}) {
    if (_grid[i][j] == p) return;

    if (_grid[i][j] == null && !_free.remove(Tuple(i, j))) {
      throw Exception("Grid is null at ($i, $j) but it's marked as filled");
    }

    if (p == null && !_free.add(Tuple(i, j))) {
      throw Exception("Trying to clear ($i, $j) but it's already empty");
    }

    if (!allowReplace && p != null && _grid[i][j] != null) {
      throw Exception('Tried to replace ${_grid[i][j]} with $p at ($i, $j)');
    }

    _grid[i][j] = p;
  }

  void setAtTuple(
    Tuple<int, int> t,
    TileProvider p, {
    bool allowReplace = true,
  }) {
    set(t.a, t.b, p, allowReplace: allowReplace);
  }

  void clearAtTuple(Tuple<int, int> t) {
    set(t.a, t.b, null);
  }

  Map<String, dynamic> toJSON() {
    return {
      'grid': _grid
          .map((line) => line.map((provider) => provider?.value ?? -1).toList())
          .toList(),
    };
  }

  bool testGameOver() {
    for (int i = 0; i < sideLength; i++) {
      for (int j = 0; j < sideLength; j++) {
        final bool skipI = i + 1 >= sideLength;
        final bool skipJ = j + 1 >= sideLength;

        if (skipI && skipJ) continue;

        final TileProvider tile = get(i, j);
        final TileProvider iNeighbor = skipI ? null : get(i + 1, j);
        final TileProvider jNeighbor = skipJ ? null : get(i, j + 1);

        if (tile.compareValue(iNeighbor)) {
          log(
            '${tile.gridPos} can merge with '
            '${iNeighbor.gridPos}: ${tile.value}',
          );

          return false;
        }

        if (tile.compareValue(jNeighbor)) {
          log(
            '${tile.gridPos} can merge with '
            '${jNeighbor.gridPos}: ${tile.value}',
          );

          return false;
        }
      }
    }

    return true;
  }

  bool swipeWithoutMerge(
    int i,
    int j,
    SwipeGestureType type,
    Tuple<int, int> origin,
  ) {
    final destination = type.isVertical ? Tuple(j, i) : Tuple(i, j);

    if (origin != destination) {
      setAtTuple(destination, getByTuple(origin));

      getByTuple(destination).gridPos = destination;
      clearAtTuple(origin);

      return true;
    }

    return false;
  }

  Tuple<int, int> swipeWithMerge(
    int i,
    int j,
    SwipeGestureType type,
    TileProvider mergeTo,
    TileProvider toBeMerged,
    List<TileProvider> toBeRemoved,
  ) {
    final destination = type.isVertical ? Tuple(j, i) : Tuple(i, j);
    final Tuple<int, int> oldPosA = Tuple.copy(mergeTo.gridPos);
    final Tuple<int, int> oldPosB = Tuple.copy(toBeMerged.gridPos);
    final int scoreAdd = 1 << (toBeMerged.value + 1);

    log('Merging $mergeTo and $toBeMerged');

    mergeTo.gridPos = destination;
    toBeMerged.gridPos = destination;

    log('Marking $mergeTo to update value');
    mergeTo.pendingValueUpdate = true;

    log('Marking $toBeMerged for deletion');
    toBeRemoved.add(toBeMerged);

    setAtTuple(destination, mergeTo);

    int tilesMoved = 0;

    if (oldPosA != destination) {
      tilesMoved++;
      clearAtTuple(oldPosA);
    }

    if (oldPosB != destination) {
      tilesMoved++;
      clearAtTuple(oldPosB);
    }

    assert(tilesMoved >= 1);

    return Tuple(tilesMoved, scoreAdd);
  }

  void log(String message) {
    Logger.log<TileGrid>(message, instance: this);
  }
}
