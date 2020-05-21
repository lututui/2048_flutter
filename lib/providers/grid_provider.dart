import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/leaderboard.dart';
import 'package:flutter_2048/providers/tile_grid.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/saved_data_manager.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/widgets/tiles/movable_tile.dart';
import 'package:provider/provider.dart';

/// Contains the main logic running the game
class GridProvider with ChangeNotifier {
  GridProvider._(this._grid, this.savedDataManager);

  /// Retrieves the nearest [GridProvider] in the widget tree
  ///
  /// See [Provider.of] with `listen: false` for more info
  factory GridProvider.of(BuildContext context) {
    return context.read<GridProvider>();
  }

  /// The instance of [SavedDataManager] for this game
  final SavedDataManager savedDataManager;

  final List<TileProvider> _pendingRemoval = [];
  final List<Widget> _tiles = [];
  final TileGrid _grid;

  /// Whether or not the game over dialog has been shown
  bool shownGameOver = false;

  bool _pendingSpawn = false;
  bool _gameOver = false;
  int _moving = 0;
  int _score = 0;

  _GameState _previousState;

  /// Loads a game from persistent storage using [savedDataManager]
  ///
  /// Returns a future that when completed contains either the loaded data
  /// wrapped in a [GridProvider] or a new instance of [GridProvider] if there
  /// was no saved game or any other problem during loading
  static Future<GridProvider> fromJSON(BuildContext context) async {
    final int gridSize = Provider.of<DimensionsProvider>(
      context,
      listen: false,
    ).gridSize;

    final GridProvider baseGrid = GridProvider._(
      TileGrid.empty(gridSize),
      SavedDataManager.grid(gridSize),
    );

    final loadedValues = await baseGrid.savedDataManager.load();

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

        baseGrid._spawnAt(Tuple(i, j), value: gridValues[i][j]);
      }
    }

    if (baseGrid._grid.freeSpaces <= 0) {
      baseGrid._gameOver = baseGrid._grid.testGameOver();
    }

    baseGrid.score = score;

    return baseGrid;
  }

  /// The Widgets for this game
  List<Widget> get tiles => _tiles;

  /// The current score
  int get score => _score;

  /// If this game is over or not
  bool get gameOver => _gameOver;

  /// If this game can go back a state
  bool get canUndo => !gameOver && _previousState != null;

  set score(int value) {
    if (_score == value) return;
    _score = value;
    notifyListeners();

    _log('New score: $_score');
  }

  set gameOver(bool gameOver) {
    if (this.gameOver == gameOver) return;

    Leaderboard.fromJSON(_grid.sideLength).then(
      (l) => l.insert(_score, _grid.sideLength),
    );

    _gameOver = gameOver;
    notifyListeners();

    _log('Game over!');
  }

  void _spawn({int amount = 1}) {
    if (_grid.freeSpaces < amount) {
      throw Exception(
        'Tried to spawn $amount but only '
        '${_grid.freeSpaces} spaces are available',
      );
    }

    for (int i = 0; i < amount; i++) {
      _spawnAt(_grid.getRandomSpawnableSpace());
    }

    savedDataManager.save(_toJSON());
    _pendingSpawn = false;
    notifyListeners();

    if (_grid.freeSpaces > 0) return;

    gameOver = _grid.testGameOver();
  }

  /// Handles the swipe gesture
  ///
  /// A swipe gesture is defined by [SwipeGestureType]. This method moves and
  /// merges the game tiles accordingly
  void swipe(SwipeGestureType type) {
    if (gameOver || _pendingSpawn || _moving > 0) return;

    final _GameState gameStateBackup = _GameState(
      TileGrid.clone(_grid),
      _score,
    );
    final int gridSize = _grid.sideLength;

    int somethingMoved = 0;
    int scoreAdd = 0;

    _log('Swipe $type');

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

        final TileProvider mergeTo = _grid.getByTuple(previous);

        if (mergeTo.value == tile.value) {
          final mergeResult = _grid.swipeWithMerge(
            i,
            newIndex,
            type,
            mergeTo,
            tile,
            _pendingRemoval,
          );

          somethingMoved += mergeResult.a;
          scoreAdd += mergeResult.b;

          previous = null;
        } else {
          if (_grid.swipeWithoutMerge(i, newIndex, type, previous)) {
            somethingMoved++;
          }

          previous = Tuple(idx1, idx2);
        }

        newIndex += type.towardsOrigin ? 1 : -1;
      }

      if (previous != null &&
          _grid.swipeWithoutMerge(i, newIndex, type, previous)) {
        somethingMoved++;
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

  /// Callback method used by a tile to tell the GridProvider it's done moving
  ///
  /// Removes the given [TileProvider] from [_pendingRemoval]
  void onMoveEnd(TileProvider tile) {
    if (_moving <= 0) {
      throw Exception(
        'Received message that tile $tile finished moving '
        'but no tiles should be moving',
      );
    }

    _moving--;

    _log('$tile finished moving');

    if (_pendingRemoval.remove(tile)) {
      final matchingTiles = _tiles
          .map((provider) => (provider.key as ObjectKey).value as TileProvider)
          .where((other) => other == tile || other.gridPos == tile.gridPos)
          .toList();

      if (matchingTiles.isEmpty || matchingTiles.length > 2) {
        throw RangeError.range(matchingTiles.length, 1, 2);
      }

      for (final t in matchingTiles) {
        if (t.moving) continue;
        if (t.pendingValueUpdate) t.updateValue();

        if (t != tile) continue;

        final List<ChangeNotifierProvider> toRemove = List.from(
          _tiles.where((p) => (p.key as ObjectKey).value == t),
        );

        if (toRemove.length != 1 || !_tiles.remove(toRemove.first)) {
          throw Exception('Failed to remove $tile from moving list');
        }

        _log('Removed ${(toRemove.first.key as ObjectKey).value}');
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

      _log('Every tile is done moving');
      _log('Spaces remaining: ${_grid.freeSpaces}');

      _spawn();
    }
  }

  Map<String, dynamic> _toJSON() {
    return {
      ..._grid.toJSON(),
      'score': _score,
    };
  }

  static Future<GridProvider> _loadFailed(GridProvider baseGrid) async {
    baseGrid._spawn(amount: 3);

    return Future.value(baseGrid);
  }

  void _spawnAt(Tuple<int, int> pos, {int value}) {
    _log('Spawning tile at $pos');

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

    _log('Spaces remaining: ${_grid.freeSpaces}');
  }

  void _log(String message) {
    Logger.log<GridProvider>(message);
  }

  /// Restores the current grid to its previous state
  void undo() {
    if (!canUndo) return;

    _log('Undo requested');

    _grid.restore(_previousState.grid, tiles: _tiles);
    notifyListeners();

    score = _previousState.score;

    _previousState = null;

    notifyListeners();
  }
}

class _GameState {
  const _GameState(this.grid, this.score);

  final TileGrid grid;
  final int score;
}
