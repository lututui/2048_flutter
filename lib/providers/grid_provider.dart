import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/tile_grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/tile.dart';
import 'package:provider/provider.dart';

class GridProvider with ChangeNotifier {
  final List<TileProvider> _pendingRemoval = List();
  final List<Widget> _tiles = List();
  final TileGrid _grid;

  bool _pendingSpawn = false;
  bool _gameOver = false;
  int _moving = 0;
  int _score = 0;

  /*
  Constructors
   */

  GridProvider._(this._grid);

  /*
  Getters
   */

  int get score => _score;

  bool get gameOver => _gameOver;

  List<Widget> get tiles => _tiles;

  /*
  Setters
   */

  set score(int value) {
    if (_score == value) return;
    _score = value;
    notifyListeners();
  }

  set gameOver(bool gameOver) {
    if (_gameOver == gameOver) return;

    _gameOver = gameOver;
    notifyListeners();
  }

  /*
  Logic
   */

  void spawn({int amount = 1}) {
    if (_grid.spawnableSpaces < amount) {
      throw Exception(
        "Tried to spawn $amount but only ${_grid.spawnableSpaces} spaces are available",
      );
    }

    for (int i = 0; i < amount; i++)
      this.spawnAt(_grid.getRandomSpawnableSpace());

    SaveManager.save(_grid.sideLength, this);
    this._pendingSpawn = false;
    notifyListeners();

    if (_grid.spawnableSpaces > 0) return;

    gameOver = _grid.testGameOver();
  }

  void spawnAt(Tuple<int, int> pos, {int value}) {
    _grid.setAtTuple(pos, TileProvider(pos, value: value), allowReplace: false);
    _tiles.add(
      ChangeNotifierProvider.value(
        key: ObjectKey(_grid.getByTuple(pos)),
        value: _grid.getByTuple(pos),
        child: const Tile(),
      ),
    );
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (gameOver) return;

    final SwipeGestureType type = details.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.UP
        : SwipeGestureType.DOWN;

    this.swipe(type);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (gameOver) return;

    final SwipeGestureType type = details.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.LEFT
        : SwipeGestureType.RIGHT;

    this.swipe(type);
  }

  void swipe(SwipeGestureType type) {
    if (_pendingSpawn || _moving > 0) return;

    int somethingMoved = 0;
    int scoreAdd = 0;

    Logger.log<GridProvider>("Swipe ${type.toDirectionString()}");

    for (int i = 0; i < _grid.sideLength; i++) {
      int newIndex = type.towardsOrigin ? 0 : _grid.sideLength - 1;
      Tuple<int, int> previous;

      for (int j = 0; j < _grid.sideLength; j++) {
        final int jIndex = type.towardsOrigin ? j : _grid.sideLength - 1 - j;
        final int idx1 = type.isVertical ? jIndex : i;
        final int idx2 = type.isVertical ? i : jIndex;
        final TileProvider tile = _grid.get(idx1, idx2);

        if (tile == null) continue;

        if (previous == null) {
          previous = Tuple(idx1, idx2);
          continue;
        }

        final Tuple<int, int> destination =
            type.isVertical ? Tuple(newIndex, i) : Tuple(i, newIndex);

        if (_grid.getByTuple(previous).value == tile.value) {
          final Tuple<int, int> oldPosA = Tuple.copy(previous);
          final Tuple<int, int> oldPosB = Tuple.copy(tile.gridPos);

          scoreAdd += 1 << (tile.value + 1);

          Logger.log<GridProvider>(
            "Merging ${_grid.getByTuple(previous)} and $tile",
          );

          _grid.getByTuple(previous).gridPos = destination;
          tile.gridPos = destination;

          _grid.getByTuple(previous).pendingValueUpdate = true;

          Logger.log<GridProvider>("Marking $tile for deletion");
          _pendingRemoval.add(tile);

          _grid.setAtTuple(destination, _grid.getByTuple(previous));

          if (oldPosA != destination) {
            somethingMoved++;
            _grid.setAtTuple(oldPosA, null);
          }

          if (oldPosB != destination) {
            somethingMoved++;
            _grid.setAtTuple(oldPosB, null);
          }

          previous = null;
        } else {
          if (previous != destination) {
            somethingMoved++;
            _grid.setAtTuple(destination, _grid.getByTuple(previous));
            _grid.getByTuple(destination).gridPos = destination;
            _grid.setAtTuple(previous, null);
          }

          previous = Tuple(idx1, idx2);
        }

        newIndex += type.towardsOrigin ? 1 : -1;
      }

      if (previous != null) {
        final Tuple<int, int> destination =
            type.isVertical ? Tuple(newIndex, i) : Tuple(i, newIndex);

        if (previous != destination) {
          somethingMoved++;
          _grid.setAtTuple(destination, _grid.getByTuple(previous));
          _grid.getByTuple(destination).gridPos = destination;
          _grid.setAtTuple(previous, null);
        }
      }
    }

    if (somethingMoved > 0) {
      this._moving += somethingMoved;
      this._pendingSpawn = true;
    }

    notifyListeners();
    score += scoreAdd;
  }

  void onMoveEnd(TileProvider tp) {
    if (_moving <= 0) {
      throw Exception([
        "Received message that tile $tp finished moving",
        "but no tiles should be moving"
      ].join(" "));
    }

    --_moving;

    if (_pendingRemoval.remove(tp)) {
      final List<TileProvider> matchingTiles = _tiles
          .map((provider) => (provider.key as ObjectKey).value as TileProvider)
          .where((other) => other == tp || other.gridPos == tp.gridPos)
          .toList();

      if (matchingTiles.length < 1 || matchingTiles.length > 2)
        throw RangeError.range(matchingTiles.length, 1, 2);

      for (TileProvider t in matchingTiles) {
        if (t.moving) continue;
        if (t.pendingValueUpdate) t.updateValue();

        if (t != tp) continue;

        final List<ChangeNotifierProvider> toRemove = List.from(
          _tiles.where((p) => (p.key as ObjectKey).value == t),
        );

        if (toRemove.length != 1 || !_tiles.remove(toRemove.first))
          throw Exception("Failed to remove $tp from moving list");

        Logger.log<GridProvider>(
            "Removed ${(toRemove.first.key as ObjectKey).value}");
      }

      notifyListeners();
    }

    if (_moving == 0 && _pendingSpawn) {
      if (_pendingRemoval.isNotEmpty) {
        throw Exception([
          "There should be no tiles moving but some are still pending removal:",
          IterableBase.iterableToFullString(_pendingRemoval),
        ].join(" "));
      }

      this.spawn();
    }
  }

  Map<String, dynamic> toJSON() => _grid.toJSON()..["score"] = score;

  static Future<GridProvider> _loadFailed(GridProvider baseGrid) async {
    baseGrid.spawn(amount: 3);

    return Future.value(baseGrid);
  }

  static Future<GridProvider> fromJSON(BuildContext context) async {
    final GridProvider baseGrid = GridProvider._(
      TileGrid(
        Provider.of<DimensionsProvider>(
          context,
          listen: false,
        ).gridSize,
      ),
    );

    final Tuple<int, List<List<int>>> loadedValues = await SaveManager.load(
      baseGrid._grid.sideLength,
    );

    if (loadedValues == null) return _loadFailed(baseGrid);

    final int score = loadedValues.a;
    final List<List<int>> gridValues = loadedValues.b;

    for (int i = 0; i < baseGrid._grid.sideLength; i++) {
      for (int j = 0; j < baseGrid._grid.sideLength; j++) {
        if (gridValues[i][j] == -1) continue;

        baseGrid.spawnAt(Tuple(i, j), value: gridValues[i][j]);
      }
    }

    if (baseGrid._grid.spawnableSpaces <= 0)
      baseGrid._gameOver = baseGrid._grid.testGameOver();
    baseGrid._score = score;

    return baseGrid;
  }
}
