import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flutter_2048/components/tile_square.dart';
import 'package:flutter_2048/extensions/int.dart';
import 'package:flutter_2048/extensions/list.dart';
import 'package:flutter_2048/extensions/swipe_gesture_type.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/util/tuple.dart';

class GameBox extends PositionComponent with HasGameRef<Game2048> {
  List<List<TileSquare>> grid;

  final Set<Tuple<int, int>> living = Set<Tuple<int, int>>();
  final Set<Tuple<int, int>> moving = Set<Tuple<int, int>>();

  int _gridSpace;

  bool _needsRecalc = true;

  @override
  final Game2048 gameRef;

  int get gridSize => this.gameRef.dimensions.gridSize;

  double get screenWidth => this.gameRef.dimensions.size.width;

  double get screenHeight => this.gameRef.dimensions.size.height;

  GameBox(this.gameRef) {
    this.grid = List<List<TileSquare>>.generate(
      this.gridSize,
      (_) => List<TileSquare>(this.gridSize),
      growable: false,
    );
    this._gridSpace = pow(this.gridSize, 2);
  }

  @override
  double get width => this.gameRef.dimensions.gameSize.width;

  @override
  double get height => this.gameRef.dimensions.gameSize.height;

  @override
  void resize(Size size) {
    this.x = (this.screenWidth - this.width) * Data.GAME_BOX_X;
    this.y = (this.screenHeight - this.height) * Data.GAME_BOX_Y;

    print("Box corner at (${this.x}, ${this.y})");

    for (Tuple<int, int> t in this.living) this.grid[t.a][t.b].resize(size);
  }

  @override
  void render(Canvas c) {
    c.drawRect(this.toRect(), Palette.BOX_BACKGROUND.paint);
    c.drawRect(
      this.toRect(),
      Palette.BOX_BORDER.paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = this.gameRef.dimensions.gapSize.width,
    );

    this.prepareCanvas(c);

    for (Tuple<int, int> t in this.living) this.grid[t.a][t.b].render(c);
  }

  @override
  void update(double t) {
    if (this.gameRef.gameOver) return;

    if (this.moving.isNotEmpty) {
      final Set<Tuple<int, int>> doneMoving = Set<Tuple<int, int>>();

      for (final Tuple<int, int> m in this.moving) {
        this.grid[m.a][m.b].update(t);

        if (!this.grid[m.a][m.b].isMoving) {
          this.grid[m.a][m.b].updateValue();
          doneMoving.add(m);
        }
      }

      if (doneMoving.isNotEmpty) this.moving.removeAll(doneMoving);

      return;
    }
  }

  void spawn({int amount = 1}) {
    List<Tuple<int, int>> freeTiles = List();

    for (int i = 0; i < this.gridSize; i++) {
      for (int j = 0; j < this.gridSize; j++) {
        if (this.grid[i][j] == null) freeTiles.add(Tuple(i, j));
      }
    }

    amount = min(amount, freeTiles.length);

    for (int i = 0; i < amount; i++) {
      Tuple<int, int> chosen = freeTiles[Data.rand.nextInt(freeTiles.length)];

      this.grid[chosen.a][chosen.b] = TileSquare(
        this,
        chosen,
        Data.SPAWN_VALUES[Data.rand.nextInt(Data.SPAWN_VALUES.length)],
      );

      if (!this.living.add(chosen))
        throw Exception("Tried to spawn tile at filled spot");
      freeTiles.remove(chosen);
      this.gridSpace--;
    }
  }

  void swipe(SwipeGestureType type) {
    if (this.moving.isNotEmpty) return;

    bool shouldSpawn = false;

    List<List<TileSquare>> newGrid = List<List<TileSquare>>.generate(
      this.gridSize,
      (_) => List<TileSquare>(this.gridSize),
      growable: false,
    );
    Set<Tuple<int, int>> pendingLiving = Set<Tuple<int, int>>();

    for (int i = 0; i < this.gridSize; i++) {
      List<TileSquare> newLineOrColumn = List<TileSquare>(this.gridSize);
      List<TileSquare> oldLineOrColumn = type.isVertical()
          ? List<TileSquare>.generate(
              this.gridSize,
              (idx) => this.grid[idx][i],
              growable: false,
            )
          : this.grid[i];

      shouldSpawn = !this.swipeLine(
            newLineOrColumn,
            oldLineOrColumn,
            reversed: type.awayFromOrigin(),
          ) ||
          shouldSpawn;

      for (int j = 0; j < this.gridSize; j++) {
        int idx1 = type.isVertical() ? j : i;
        int idx2 = type.isVertical() ? i : j;

        if (this.grid[idx1][idx2] == newLineOrColumn[j]) {
          newGrid[idx1][idx2] = TileSquare.copy(newLineOrColumn[j]);
          continue;
        }

        if (this.grid[idx1][idx2] != null &&
            !this.living.remove(this.grid[idx1][idx2].gridPosition))
          throw Exception("Failed to remove ($idx1, $idx2)");

        newGrid[idx1][idx2] = TileSquare.copy(newLineOrColumn[j]);

        if (newLineOrColumn[j] != null) {
          newGrid[idx1][idx2].updateGridPosition(idx1, idx2);

          if (newGrid[idx1][idx2].isMoving)
            this.moving.add(newGrid[idx1][idx2].gridPosition);

          pendingLiving.add(newGrid[idx1][idx2].gridPosition);
        }
      }
    }

    this.living.addAll(pendingLiving);
    this.grid = newGrid;
    if (shouldSpawn) this.spawn();
  }

  bool swipeLine(
    List<TileSquare> newList,
    List<TileSquare> oldList, {
    bool reversed = false,
  }) {
    TileSquare previous;
    int k = reversed ? this.gridSize - 1 : 0;

    for (int i = 0; i < this.gridSize; i++) {
      int j = reversed ? this.gridSize - 1 - i : i;

      if (oldList[j] == null) continue;

      if (previous == null) {
        previous = oldList[j];
        continue;
      }

      bool merge = previous.value == oldList[j].value;

      if (merge) {
        previous.merge(oldList[j]);
        this.gameRef.score.value += 2.safeLShift(previous.value);
        this.gridSpace++;

        print("New score: ${this.gameRef.score}");
      }

      newList[k] = previous;
      previous = merge ? null : oldList[j];
      k += reversed ? -1 : 1;
    }

    if (previous != null) newList[k] = previous;

    return newList.equalContents<TileSquare>(oldList);
  }

  int get gridSpace => this._gridSpace;

  set gridSpace(int value) {
    this._gridSpace = value;

    print("Remaining gridSpace: ${this._gridSpace}");

    this._needsRecalc = true;

    if (this._gridSpace < 0 || this._gridSpace > this.gridSize * this.gridSize)
      throw Exception("Gridspace exceeded: ${this._gridSpace}");
  }

  void calcGameOver() {
    if (!this._needsRecalc) return;
    if (this._gridSpace > 0 || this.gameRef.gameOver || this.moving.isNotEmpty)
      return;

    for (int i = 0; i < this.gridSize; i++) {
      for (int j = 0; j < this.gridSize; j++) {
        final bool idx1 = i + 1 >= this.gridSize;
        final bool idx2 = j + 1 >= this.gridSize;

        if (idx1 && idx2) continue;

        final TileSquare pos1 = this.grid[i][j];
        final TileSquare pos2 = (idx2) ? null : this.grid[i][j + 1];
        final TileSquare pos3 = (idx1) ? null : this.grid[i + 1][j];

        if (pos2 != null && pos1.value == pos2.value) {
          print("${pos1.gridPosition} can merge with ${pos2.gridPosition}");
          this._needsRecalc = false;
          return;
        }

        if (pos3 != null && pos1.value == pos3.value) {
          print("${pos1.gridPosition} can merge with ${pos3.gridPosition}");
          this._needsRecalc = false;
          return;
        }
      }
    }

    print("Game over!");

    this.gameRef.gameOver = true;
  }
}
