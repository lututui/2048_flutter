import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:provider/provider.dart';

class DimensionsProvider with ChangeNotifier {
  DimensionsProvider() : _gridSize = _defaultGridSize;

  static const int _defaultGridSize = 4;

  Size _screenSize;
  Size _tileSize;
  Size _gapSize;
  Size _gameSize;

  int _gridSize;

  static int getGridSize(BuildContext context) {
    return context.read<DimensionsProvider>().gridSize;
  }

  static void setGridSize(BuildContext context, int newSize) {
    context.read<DimensionsProvider>().gridSize = newSize;
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

    log('Changed gridSize to $_gridSize');

    if (_screenSize != null) {
      log('Updating other sizes');
      _updateSizes();
    }
  }

  void _updateSizes() {
    final int nullCount = [
      _tileSize,
      _gapSize,
      _gameSize,
    ].where((k) => k == null).length;

    final oldValues = <Size>[
      if (_tileSize != null) Size.copy(_tileSize) else null,
      if (_gapSize != null) Size.copy(_gapSize) else null,
      if (_gameSize != null) Size.copy(_gameSize) else null,
    ];

    final Map<String, Size> sizes = calculateSizes(_screenSize, _gridSize);
    final List<String> stringBuilder = [];

    if (sizes['tile'] != _tileSize) {
      _tileSize = sizes['tile'];
      stringBuilder.add('\ttileSize (from: ${oldValues[0]}, to $_tileSize)');
    }

    if (sizes['gap'] != _gapSize) {
      _gapSize = sizes['gap'];
      stringBuilder.add('\tgapSize (from ${oldValues[1]}, to $_gapSize)');
    }

    if (sizes['game'] != _gameSize) {
      _gameSize = sizes['game'];
      stringBuilder.add('\tgameSize (from ${oldValues[2]}, to $_gameSize)');
    }

    if (nullCount > 0) {
      debugWarnNotify(stringBuilder);
      notifyListeners();
    }
  }

  void updateScreenSize(BuildContext context) {
    final Size newSize = MediaQuery.of(context).size;

    if (_screenSize == newSize) return;

    _screenSize = newSize;

    _updateSizes();
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
      'tile': tileSize,
      'gap': gapSize,
      'game': gameSize,
    };
  }

  void debugWarnNotify(Iterable updatedValues) {
    log('Triggered a notification to listeners.\n${updatedValues.join(',\n')}');
  }
}
