import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DimensionsProvider with ChangeNotifier {
  final int gridSize;

  Size _screenSize;
  Size _tileSize;
  Size _gapSize;
  Size _gameSize;

  DimensionsProvider(Size s, this.gridSize) {
    this.screenSize = s;
  }

  factory DimensionsProvider.from(BuildContext context, int gridSize) {
    return DimensionsProvider(MediaQuery.of(context).size, gridSize);
  }

  factory DimensionsProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<DimensionsProvider>(context, listen: listen);
  }

  Size get gapSize => _gapSize;

  Size get gameSize => _gameSize;

  Size get screenSize => _screenSize;

  Size get tileSize => _tileSize;

  set screenSize(Size value) {
    _screenSize = value;

    _tileSize = Size.square(min(value.width, value.height) / (gridSize + 2));
    _gapSize = _tileSize / (2.0 * gridSize);
    _gameSize = Size.square(
        gridSize * (_tileSize.width + _gapSize.width) + _gapSize.width);

    notifyListeners();
  }
}
