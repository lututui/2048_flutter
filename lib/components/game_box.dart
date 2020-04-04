import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter_2048/components/tile_square.dart';
import 'package:flutter_2048/gesture_recognizer/SwipeGestureRecognizer.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/util/tuple.dart';

class GameBox extends PositionComponent {
  List<List<TileSquare>> grid;
  final int gridSize;
  Size screenSize;

  Size tileSize;
  Size gapSize;
  Size gameSize;

  Set<Tuple<int, int>> living;
  Set<Tuple<int, int>> moving;

  int _gridSpace;

  bool gameOver;

  GameBox(this.gridSize, this.screenSize) {
    this.living = Set<Tuple<int, int>>();
    this.moving = Set<Tuple<int, int>>();
    this.grid = List<List<TileSquare>>.generate(
      this.gridSize,
      (_) => List<TileSquare>(this.gridSize),
      growable: false,
    );
    this._gridSpace = this.gridSize * this.gridSize;
    this.gameOver = false;

    this._layout();
    this.spawn(amount: 3);
  }

  void _layout() {
    this.tileSize = Size.square(min(
      this.screenSize.width / (this.gridSize + 2),
      this.screenSize.height / (this.gridSize + 2),
    ));

    this.gapSize = Size.square(this.tileSize.width / (2 * this.gridSize));

    this.gameSize = Size.square(
        (this.tileSize.width + this.gapSize.width) * this.gridSize +
            this.gapSize.width);

    print("Screen size: ${this.screenSize}");
    print("Grid size: ${this.gridSize}");
    print("Tile size: ${this.tileSize}");
    print("Gap size: ${this.gapSize}");
    print("Game size: ${this.gameSize}");

    this.x = (this.screenSize.width - this.gameSize.width) / 2.0;
    this.y = (this.screenSize.height - this.gameSize.height) * 2.0 / 3.0;

    print("Box corner at (${this.x}, ${this.y})");

    this.width = this.gameSize.width;
    this.height = this.gameSize.height;
  }

  @override
  void resize(Size size) {
    this.screenSize = size;
    this._layout();

    for (Tuple<int, int> t in this.living) {
      this.grid[t.a][t.b].width = this.tileSize.width;
      this.grid[t.a][t.b].height = this.tileSize.height;
      this.grid[t.a][t.b].gapSize = this.gapSize;
      this.grid[t.a][t.b].resize(size);
    }

    super.resize(size);
  }

  @override
  void render(Canvas c) {
    c.drawRect(this.toRect(), Palette.lavenderGray.paint);
    c.drawRect(
      this.toRect(),
      Palette.x11Gray.paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = this.gapSize.width,
    );

    this.prepareCanvas(c);

    for (Tuple<int, int> t in this.living) this.grid[t.a][t.b].render(c);
  }

  @override
  void update(double t) {
    if (this.gameOver) return;

    if (this.moving.isNotEmpty) {
      Set<Tuple<int, int>> doneMoving = Set();

      for (Tuple<int, int> m in this.moving) {
        this.grid[m.a][m.b].update(t);

        if (!this.grid[m.a][m.b].isMoving) {
          this.grid[m.a][m.b].updateValue();
          doneMoving.add(m);
        }
      }

      this.moving.removeAll(doneMoving);
      return;
    }

    if (!gameOver) this._calcGameOver();
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
        chosen,
        Data.spawnValues[Data.rand.nextInt(Data.spawnValues.length)],
        this.tileSize,
        this.gapSize,
      );

      if (!this.living.add(chosen))
        throw Exception("Tried to spawn tile at filled spot");
      freeTiles.remove(chosen);
      this.gridSpace--;
    }
  }

  void swipe(SwipeGestureType type) {
    if (this.moving.isNotEmpty) return;

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

      this._doSwipe(
        newLineOrColumn,
        oldLineOrColumn,
        reversed: type.awayFromOrigin(),
      );

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
    this.spawn();
  }

  void _doSwipe(
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
        this.gridSpace++;
      }

      newList[k] = previous;
      previous = merge ? null : oldList[j];
      k += reversed ? -1 : 1;
    }

    if (previous != null) newList[k] = previous;
  }

  int get gridSpace => this._gridSpace;

  set gridSpace(int value) {
    this._gridSpace = value;

    print("Remaining gridSpace: ${this._gridSpace}");

    if (this._gridSpace < 0 || this._gridSpace > this.gridSize * this.gridSize)
      throw Exception("Gridspace exceeded: ${this._gridSpace}");
  }

  void _calcGameOver() {
    if (this._gridSpace > 0 || this.gameOver) return;

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
          return;
        }

        if (pos3 != null && pos1.value == pos3.value) {
          print("${pos1.gridPosition} can merge with ${pos3.gridPosition}");
          return;
        }
      }
    }

    print("Game over!");

    this.gameOver = true;
  }
}
