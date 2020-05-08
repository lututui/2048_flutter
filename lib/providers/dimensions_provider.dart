import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:provider/provider.dart';

class DimensionsProvider with ChangeNotifier {
  static const int _DEFAULT_GRID_SIZE = 4;

  Size _screenSize;
  Size _tileSize;
  Size _gapSize;
  Size _gameSize;

  int _gridSize;

  DimensionsProvider() : _gridSize = _DEFAULT_GRID_SIZE;

  factory DimensionsProvider.of(BuildContext context) {
    return Provider.of<DimensionsProvider>(context, listen: false);
  }

  static int getGridSize(BuildContext context) {
    return DimensionsProvider.of(context).gridSize;
  }

  static void setGridSize(BuildContext context, int newSize) {
    DimensionsProvider.of(context).gridSize = newSize;
  }

  void log(String message) {
    Logger.log<DimensionsProvider>(message);
  }

  double get aspectRatio {
    return _gameSize.width / (_tileSize.height + _gridSize * _gapSize.width);
  }

  Size get gapSize => _gapSize;

  Size get gameSize => _gameSize;

  Size get screenSize => _screenSize;

  Size get tileSize => _tileSize;

  int get gridSize => _gridSize;

  set gridSize(int value) {
    _gridSize = value;

    this.log("Changed gridSize to $_gridSize");

    if (_screenSize != null) {
      this.log("Updating other sizes");
      this._updateSizes();
    }
  }

  void _updateSizes() {
    final bool skipNotify = [
      _tileSize,
      _gapSize,
      _gameSize,
    ].any((k) => k == null);

    if (skipNotify) {
      this.log("Won't notifty listeners ($_tileSize, $_gapSize, $_gameSize)");
    }

    final Map<String, Size> sizes = calculateSizes(_screenSize, _gridSize);

    _tileSize = sizes["tile"];
    _gapSize = sizes["gap"];
    _gameSize = sizes["game"];

    this.log("Updated values: ($_tileSize, $_gapSize, $_gameSize)");

    if (!skipNotify) {
      notifyListeners();
    }
  }

  void updateScreenSize(BuildContext context) {
    final Size newSize = MediaQuery.of(context).size;

    if (_screenSize == newSize) return;

    _screenSize = newSize;

    this._updateSizes();
  }

  static Map<String, Size> calculateSizes(Size screenSize, int gridSize) {
    final Size tileSize = Size.square(
      min(screenSize.width, screenSize.height) / (gridSize + 2),
    );
    final Size gapSize = tileSize / (2.0 * gridSize);
    final Size gameSize = Size.square(
      gridSize * (tileSize.width + gapSize.width) + gapSize.width,
    );

    return <String, Size>{
      "tile": tileSize,
      "gap": gapSize,
      "game": gameSize,
    };
  }
}
