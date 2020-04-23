import 'package:flutter/foundation.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';

abstract class Grid<T> {
  final List<List<T>> _grid;
  final Set<Tuple<int, int>> _free;

  Grid(this._grid, this._free);

  @protected
  List<List<T>> get grid => _grid;

  int get sideLength => _grid.length;

  int get flattenLength => _grid.length * _grid.length;

  List<Tuple<int, int>> get spawnableSpacesList => List.unmodifiable(_free);

  int get spawnableSpaces => _free.length;

  T get(int i, int j) => _grid[i][j];

  T getByTuple(Tuple<int, int> t) => _grid[t.a][t.b];

  Tuple<int, int> getRandomSpawnableSpace() {
    return spawnableSpacesList[Data.rand.nextInt(_free.length)];
  }

  void set(int i, int j, T p, {bool allowReplace = true}) {
    if (_grid[i][j] == p) return;

    if (_grid[i][j] == null && !_free.remove(Tuple(i, j)))
      throw Exception("Grid is null at ($i, $j) but it's marked as filled");

    if (p == null && !_free.add(Tuple(i, j)))
      throw Exception("Trying to clear ($i, $j) but it's already empty");

    if (!allowReplace && p != null && _grid[i][j] != null)
      throw Exception("Tried to replace ${_grid[i][j]} with $p at ($i, $j)");

    _grid[i][j] = p;
  }

  void setAtTuple(Tuple<int, int> t, T p, {bool allowReplace = true}) {
    this.set(t.a, t.b, p, allowReplace: allowReplace);
  }


  Map<String, dynamic> toJSON();
}
