import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/leaderboard.dart';
import 'package:flutter_2048/providers/tile_grid.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/save_state.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/widgets/tiles/movable_tile.dart';
import 'package:provider/provider.dart';

class GameState {
  GameState(this.grid, this.score);

  final TileGrid grid;
  final int score;
}

class GridProvider with ChangeNotifier {
  GridProvider(this._grid, this.saveState);

  factory GridProvider.of(BuildContext context) {
    return context.read<GridProvider>();
  }

  final SaveState saveState;

  final List<TileProvider> _pendingRemoval = [];
  final List<Widget> _tiles = [];
  final TileGrid _grid;

  bool _pendingSpawn = false;
  bool _gameOver = false;
  int _moving = 0;
  int _score = 0;

  GameState _previousState;

  static Future<GridProvider> fromJSON(BuildContext context) async {
    final int gridSize = DimensionsProvider.getGridSize(context);

    final GridProvider baseGrid = GridProvider(
      TileGrid.empty(gridSize),
      SaveState.grid(gridSize),
    );

    final Map<String, dynamic> loadedValues = await baseGrid.saveState.load();

    if (loadedValues == null) {
      return _loadFailed(baseGrid);
    }

    final int score = loadedValues['score'] as int;
    final List<List<int>> gridValues = (loadedValues['grid'] as List<dynamic>)
        .map((line) => List<int>.from(line as Iterable))
        .toList();

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (gridValues[i][j] == -1) continue;

        baseGrid.spawnAt(Tuple(i, j), value: gridValues[i][j]);
      }
    }

    if (baseGrid._grid.spawnableSpaces <= 0) {
      baseGrid._gameOver = baseGrid._grid.testGameOver();
    }

    baseGrid.score = score;

    return baseGrid;
  }

  /*
  Getters
   */

  List<Widget> get tiles => _tiles;

  int get score => _score;

  bool get gameOver => _gameOver;

  bool get canUndo => !_gameOver && _previousState != null;

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

    Leaderboard.fromJSON(_grid.sideLength).then(
      (l) => l.insert(_score, _grid.sideLength),
    );

    _gameOver = gameOver;
    notifyListeners();
  }

  /*
  Logic
   */

  void spawn({int amount = 1}) {
    if (_grid.spawnableSpaces < amount) {
      throw Exception(
        'Tried to spawn $amount but only '
        '${_grid.spawnableSpaces} spaces are available',
      );
    }

    for (int i = 0; i < amount; i++) {
      spawnAt(_grid.getRandomSpawnableSpace());
    }

    saveState.save(toJSON());
    _pendingSpawn = false;
    notifyListeners();

    if (_grid.spawnableSpaces > 0) return;

    _gameOver = _grid.testGameOver();
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (_gameOver) return;

    final SwipeGestureType type = details.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.up
        : SwipeGestureType.down;

    swipe(type);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (_gameOver) return;

    final SwipeGestureType type = details.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.left
        : SwipeGestureType.right;

    swipe(type);
  }

  void swipe(SwipeGestureType type) {
    if (_pendingSpawn || _moving > 0) return;

    final GameState gameStateBackup = GameState(_grid.clone(), _score);
    final int gridSize = _grid.sideLength;

    int somethingMoved = 0;
    int scoreAdd = 0;

    log('Swipe ${type.directionString}');

    for (int i = 0; i < gridSize; i++) {
      int newIndex = type.towardsOrigin ? 0 : gridSize - 1;
      Tuple<int, int> previous;

      for (int j = 0; j < gridSize; j++) {
        final int jIndex = type.towardsOrigin ? j : gridSize - 1 - j;
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

          log('Merging ${_grid.getByTuple(previous)} and $tile');

          _grid.getByTuple(previous).gridPos = destination;
          tile.gridPos = destination;

          log('Marking ${_grid.getByTuple(previous)} to update value');
          _grid.getByTuple(previous).pendingValueUpdate = true;

          log('Marking $tile for deletion');
          _pendingRemoval.add(tile);

          _grid.setAtTuple(
            destination,
            _grid.getByTuple(previous),
          );

          if (oldPosA != destination) {
            somethingMoved++;
            _grid.clearAtTuple(oldPosA);
          }

          if (oldPosB != destination) {
            somethingMoved++;
            _grid.clearAtTuple(oldPosB);
          }

          previous = null;
        } else {
          if (previous != destination) {
            somethingMoved++;

            _grid.setAtTuple(
              destination,
              _grid.getByTuple(previous),
            );

            _grid.getByTuple(destination).gridPos = destination;
            _grid.clearAtTuple(previous);
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

          _grid.setAtTuple(
            destination,
            _grid.getByTuple(previous),
          );

          _grid.getByTuple(destination).gridPos = destination;
          _grid.clearAtTuple(previous);
        }
      }
    }

    if (somethingMoved > 0) {
      _previousState = gameStateBackup;
      _moving += somethingMoved;
      _pendingSpawn = true;
    }

    notifyListeners();
    score += scoreAdd;
  }

  void onMoveEnd(TileProvider tp) {
    if (_moving <= 0) {
      throw Exception(
        'Received message that tile $tp finished moving '
        'but no tiles should be moving',
      );
    }

    _moving--;

    if (_pendingRemoval.remove(tp)) {
      final List<TileProvider> matchingTiles = _tiles
          .map((provider) => (provider.key as ObjectKey).value as TileProvider)
          .where((other) => other == tp || other.gridPos == tp.gridPos)
          .toList();

      if (matchingTiles.isEmpty || matchingTiles.length > 2) {
        throw RangeError.range(matchingTiles.length, 1, 2);
      }

      for (final t in matchingTiles) {
        if (t.moving) continue;
        if (t.pendingValueUpdate) t.updateValue();

        if (t != tp) continue;

        final List<ChangeNotifierProvider> toRemove = List.from(
          _tiles.where((p) => (p.key as ObjectKey).value == t),
        );

        if (toRemove.length != 1 || !_tiles.remove(toRemove.first)) {
          throw Exception('Failed to remove $tp from moving list');
        }

        log('Removed ${(toRemove.first.key as ObjectKey).value}');
      }

      notifyListeners();
    }

    if (_moving == 0 && _pendingSpawn) {
      if (_pendingRemoval.isNotEmpty) {
        throw Exception(
          'There should be no tiles moving but some are still pending removal: '
          '${IterableBase.iterableToFullString(_pendingRemoval)}',
        );
      }

      spawn();
    }
  }

  Map<String, dynamic> toJSON() {
    return {
      ..._grid.toJSON(),
      'score': _score,
    };
  }

  static Future<GridProvider> _loadFailed(GridProvider baseGrid) async {
    baseGrid.spawn(amount: 3);

    return Future.value(baseGrid);
  }

  void spawnAt(Tuple<int, int> pos, {int value}) {
    _grid.setAtTuple(
      pos,
      TileProvider(
        pos,
        value ?? SizeOptions.nextSpawnValueBySideLength(_grid.sideLength),
      ),
      allowReplace: false,
    );

    _tiles.add(
      ChangeNotifierProvider.value(
        key: ObjectKey(_grid.getByTuple(pos)),
        value: _grid.getByTuple(pos),
        child: const MovableTile(),
      ),
    );
  }

  void log(String message) {
    Logger.log<GridProvider>(message);
  }

  void undo() {
    if (!canUndo) return;

    _grid.restore(_previousState.grid, tiles: _tiles);
    notifyListeners();

    score = _previousState.score;

    _previousState = null;

    notifyListeners();
  }
}
