import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/providers/tile_provider.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/tile.dart';
import 'package:provider/provider.dart';

class GridProvider with ChangeNotifier {
  final List<Widget> _tiles = List();
  final List<TileProvider> _pendingRemoval = List();
  final List<List<TileProvider>> _grid;

  bool _pendingSpawn = false;
  int _moving = 0;

  GridProvider._(this._grid) {
    this.spawn(amount: 3);
  }

  factory GridProvider(BuildContext context) {
    final int gridSize = Provider.of<DimensionsProvider>(
      context,
      listen: false,
    ).gridSize;

    return GridProvider._(
      List.generate(gridSize, (_) => List(gridSize), growable: false),
    );
  }

  void spawn({int amount = 1}) {
    final List<Tuple<int, int>> pos = List();

    for (int i = 0; i < _grid.length; i++) {
      for (int j = 0; j < _grid.length; j++) {
        if (_grid[i][j] != null) continue;

        pos.add(Tuple(i, j));
      }
    }

    if (pos.length < amount) {
      throw Exception(
        "Tried to spawn $amount but only ${pos.length} spaces are available",
      );
    }

    for (int i = 0; i < amount; i++) {
      final Tuple<int, int> p = pos[Data.rand.nextInt(pos.length)];

      _grid[p.a][p.b] = TileProvider(p);
      _tiles.add(
        ChangeNotifierProvider.value(
          key: ObjectKey(_grid[p.a][p.b]),
          value: _grid[p.a][p.b],
          child: const Tile(),
        ),
      );

      if (!pos.remove(p)) throw Exception("Failed mark position $p as filled");
    }

    this._pendingSpawn = false;
    notifyListeners();
  }

  List<Widget> get tiles => _tiles;

  void onVerticalDragEnd(DragEndDetails details, BuildContext context) {
    final SwipeGestureType type = details.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.UP
        : SwipeGestureType.DOWN;

    this.swipe(type, Provider.of<ScoreProvider>(context, listen: false));
  }

  void onHorizontalDragEnd(DragEndDetails details, BuildContext context) {
    final SwipeGestureType type = details.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.LEFT
        : SwipeGestureType.RIGHT;

    this.swipe(type, Provider.of<ScoreProvider>(context, listen: false));
  }

  void swipe(SwipeGestureType type, ScoreProvider scoreProvider) {
    if (_pendingSpawn || _moving > 0) return;

    int somethingMoved = 0;
    int scoreAdd = 0;

    print("Swipe ${type.toDirectionString()}");

    for (int i = 0; i < _grid.length; i++) {
      int newIndex = type.towardsOrigin ? 0 : _grid.length - 1;
      Tuple<int, int> previous;

      for (int j = 0; j < _grid.length; j++) {
        int jIndex = type.towardsOrigin ? j : _grid.length - 1 - j;
        int idx1 = type.isVertical ? jIndex : i;
        int idx2 = type.isVertical ? i : jIndex;
        TileProvider tile = _grid[idx1][idx2];

        if (tile == null) continue;

        if (previous == null) {
          previous = Tuple(idx1, idx2);
          continue;
        }

        final Tuple<int, int> destination =
            type.isVertical ? Tuple(newIndex, i) : Tuple(i, newIndex);

        if (_grid[previous.a][previous.b].value == tile.value) {
          final Tuple<int, int> oldPosA = Tuple.copy(previous);
          final Tuple<int, int> oldPosB = Tuple.copy(tile.gridPos);

          scoreAdd += 1 << (tile.value + 1);

          print("Merging ${_grid[previous.a][previous.b]} and $tile");

          _grid[previous.a][previous.b].gridPos = destination;
          tile.gridPos = destination;

          _grid[previous.a][previous.b].pendingValueUpdate = true;

          print("Marking $tile for deletion");
          _pendingRemoval.add(tile);

          _grid[destination.a][destination.b] = _grid[previous.a][previous.b];

          if (oldPosA != destination) {
            somethingMoved++;
            _grid[oldPosA.a][oldPosA.b] = null;
          }

          if (oldPosB != destination) {
            somethingMoved++;
            _grid[oldPosB.a][oldPosB.b] = null;
          }

          previous = null;
        } else {
          if (previous != destination) {
            somethingMoved++;
            _grid[destination.a][destination.b] = _grid[previous.a][previous.b];
            _grid[destination.a][destination.b].gridPos = destination;
            _grid[previous.a][previous.b] = null;
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
          _grid[destination.a][destination.b] = _grid[previous.a][previous.b];
          _grid[destination.a][destination.b].gridPos = destination;
          _grid[previous.a][previous.b] = null;
        }
      }
    }

    if (somethingMoved > 0) {
      this._moving += somethingMoved;
      this._pendingSpawn = true;
    }

    notifyListeners();
    scoreProvider.value += scoreAdd;
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
          .map((provider) => (provider.key as ObjectKey).value)
          .cast<TileProvider>()
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

        print("Removed ${(toRemove.first.key as ObjectKey).value}");
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
}
