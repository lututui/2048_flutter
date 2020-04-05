import 'dart:math';
import 'dart:ui';

import 'package:flame/components/mixins/resizable.dart';

class GameDimensions with Resizable {
  int gridSize;

  Size tileSize;
  Size gapSize;
  Size gameSize;

  @override
  void resize(Size size) {
    this.size = size;

    this.tileSize = Size.square(min(
      this.size.width / (this.gridSize + 2),
      this.size.height / (this.gridSize + 2),
    ));

    this.gapSize = Size.square(this.tileSize.width / (2 * this.gridSize));

    this.gameSize = Size.square(
      (this.tileSize.width + this.gapSize.width) * this.gridSize +
          this.gapSize.width,
    );

    print("Screen size: ${this.size}");
    print("Grid size: ${this.gridSize}");
    print("Tile size: ${this.tileSize}");
    print("Gap size: ${this.gapSize}");
    print("Game size: ${this.gameSize}");
  }
}
