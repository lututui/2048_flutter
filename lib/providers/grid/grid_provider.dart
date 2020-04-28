import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/base_grid_provider.dart';
import 'package:flutter_2048/providers/tile/tile_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/leaderboard.dart';
import 'package:flutter_2048/util/tile_grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/movable_tile.dart';
import 'package:provider/provider.dart';

class GridProvider extends BaseGridProvider with ChangeNotifier {
  final List<TileProvider> _pendingRemoval = List();
  @override
  TileGrid grid;

  bool _pendingSpawn = false;
  bool _gameOver = false;
  int _moving = 0;
  int _score = 0;

  /*
  Constructors
   */

  GridProvider._(this.grid) : super();

  factory GridProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<GridProvider>(context, listen: listen);
  }

  static Future<GridProvider> fromJSON(BuildContext context) async {
    final GridProvider baseGrid = GridProvider._(
      TileGrid(DimensionsProvider.of(context, listen: false).gridSize),
    );

    final Tuple<int, List<List<int>>> loadedValues = await SaveManager.load(
      baseGrid.grid.sideLength,
    );

    if (loadedValues == null) return _loadFailed(baseGrid);

    final int score = loadedValues.a;
    final List<List<int>> gridValues = loadedValues.b;

    for (int i = 0; i < baseGrid.grid.sideLength; i++) {
      for (int j = 0; j < baseGrid.grid.sideLength; j++) {
        if (gridValues[i][j] == -1) continue;

        baseGrid.spawnAt(Tuple(i, j), value: gridValues[i][j]);
      }
    }

    if (baseGrid.grid.spawnableSpaces <= 0)
      baseGrid._gameOver = baseGrid.grid.testGameOver();

    baseGrid._score = score;

    return baseGrid;
  }

  /*
  Getters
   */

  int get score => _score;

  bool get gameOver => _gameOver;

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

    Leaderboard.fromJSON(grid.sideLength).then(
      (l) => l.insert(_score, grid.sideLength),
    );

    _gameOver = gameOver;
    notifyListeners();
  }

  /*
  Logic
   */

  @override
  void spawn({int amount = 1}) {
    super.spawn(amount: amount);

    SaveManager.save(grid.sideLength, this);
    this._pendingSpawn = false;
    notifyListeners();

    if (grid.spawnableSpaces > 0) return;

    gameOver = grid.testGameOver();
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

    for (int i = 0; i < grid.sideLength; i++) {
      int newIndex = type.towardsOrigin ? 0 : grid.sideLength - 1;
      Tuple<int, int> previous;

      for (int j = 0; j < grid.sideLength; j++) {
        final int jIndex = type.towardsOrigin ? j : grid.sideLength - 1 - j;
        final int idx1 = type.isVertical ? jIndex : i;
        final int idx2 = type.isVertical ? i : jIndex;
        final TileProvider tile = grid.get(idx1, idx2);

        if (tile == null) continue;

        if (previous == null) {
          previous = Tuple(idx1, idx2);
          continue;
        }

        final Tuple<int, int> destination =
            type.isVertical ? Tuple(newIndex, i) : Tuple(i, newIndex);

        if (grid.getByTuple(previous).value == tile.value) {
          final Tuple<int, int> oldPosA = Tuple.copy(previous);
          final Tuple<int, int> oldPosB = Tuple.copy(tile.gridPos);

          scoreAdd += 1 << (tile.value + 1);

          Logger.log<GridProvider>(
            "Merging ${grid.getByTuple(previous)} and $tile",
          );

          grid.getByTuple(previous).gridPos = destination;
          tile.gridPos = destination;

          grid.getByTuple(previous).pendingValueUpdate = true;

          Logger.log<GridProvider>("Marking $tile for deletion");
          _pendingRemoval.add(tile);

          grid.setAtTuple(destination, grid.getByTuple(previous));

          if (oldPosA != destination) {
            somethingMoved++;
            grid.setAtTuple(oldPosA, null);
          }

          if (oldPosB != destination) {
            somethingMoved++;
            grid.setAtTuple(oldPosB, null);
          }

          previous = null;
        } else {
          if (previous != destination) {
            somethingMoved++;
            grid.setAtTuple(destination, grid.getByTuple(previous));
            grid.getByTuple(destination).gridPos = destination;
            grid.setAtTuple(previous, null);
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
          grid.setAtTuple(destination, grid.getByTuple(previous));
          grid.getByTuple(destination).gridPos = destination;
          grid.setAtTuple(previous, null);
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
      final List<TileProvider> matchingTiles = tiles
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
          tiles.where((p) => (p.key as ObjectKey).value == t),
        );

        if (toRemove.length != 1 || !tiles.remove(toRemove.first))
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

  Map<String, dynamic> toJSON() => grid.toJSON()..["score"] = score;

  static Future<GridProvider> _loadFailed(GridProvider baseGrid) async {
    baseGrid.spawn(amount: 3);

    return Future.value(baseGrid);
  }

  @override
  void spawnAt(Tuple<int, int> pos, {int value}) {
    grid.setAtTuple(pos, TileProvider(pos, value: value), allowReplace: false);
    tiles.add(
      ChangeNotifierProvider.value(
        key: ObjectKey(grid.getByTuple(pos)),
        value: grid.getByTuple(pos),
        child: const MovableTile(),
      ),
    );
  }
}
