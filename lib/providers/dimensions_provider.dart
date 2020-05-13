import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:provider/provider.dart';

class DimensionsProvider with ChangeNotifier {
  DimensionsProvider();

  static const int _defaultGridSize = 4;

  Size _screenSize;
  double _tileSize;
  double _gapSize;
  double _gameSize;
  int _gridSize;

  static int getGridSize(BuildContext context) {
    return context.read<DimensionsProvider>().gridSize;
  }

  static int setGridSize(BuildContext context, int newSize) {
    return context.read<DimensionsProvider>().gridSize = newSize;
  }

  ChangeNotifierProvider<DimensionsProvider> get changeNotifierProvider {
    return ChangeNotifierProvider.value(value: this);
  }

  void log(String message) {
    Logger.log<DimensionsProvider>(message);
  }

  double getAspectRatio(BuildContext context) {
    updateScreenSize(MediaQuery.of(context).size);

    return _gameSize / (_tileSize + _gridSize * _gapSize);
  }

  double getGapSize(BuildContext context) {
    updateScreenSize(MediaQuery.of(context).size);

    return _gapSize;
  }

  double getGameSize(BuildContext context) {
    updateScreenSize(MediaQuery.of(context).size);

    return _gameSize;
  }

  double getTileSize(BuildContext context) {
    updateScreenSize(MediaQuery.of(context).size);

    return _tileSize;
  }

  Size getScreenSize(BuildContext context) {
    updateScreenSize(MediaQuery.of(context).size);

    return _screenSize;
  }

  int get gridSize => _gridSize ??= _defaultGridSize;

  set gridSize(int value) {
    _gridSize = value;

    log('Changed gridSize to $_gridSize');

    if (_screenSize != null) {
      log('Updating other sizes');
      _updateSizes();
    } else {
      notifyListeners();
    }
  }

  void _updateSizes() {
    final double newTileSize =
        min(_screenSize.width, _screenSize.height) / (gridSize + 2);
    final double newGapSize = newTileSize / (2.0 * gridSize);
    final double newGameSize =
        gridSize * (newTileSize + newGapSize) + newGapSize;

    final List<String> stringBuilder = [];

    bool willNotify = false;

    if (newTileSize != _tileSize) {
      if (_tileSize != null) {
        stringBuilder.add(
          _valueChangedString(_tileSize, newTileSize, 'tileSize'),
        );
        willNotify = true;
      }

      _tileSize = newTileSize;
    }

    if (newGapSize != _gapSize) {
      if (_gapSize != null) {
        stringBuilder.add(
          _valueChangedString(_gapSize, newGapSize, 'gapSize'),
        );
        willNotify = true;
      }

      _gapSize = newGapSize;
    }

    if (newGameSize != _gameSize) {
      if (_gameSize != null) {
        stringBuilder.add(
          _valueChangedString(_gameSize, newGameSize, 'gameSize'),
        );
        willNotify = true;
      }

      _gameSize = newGameSize;
    }

    if (willNotify) {
      log(
        'Triggered a notification to listeners.\n'
        '${stringBuilder.join(',\n')}',
      );

      notifyListeners();
    }
  }

  bool updateScreenSize(Size newSize) {
    if (_screenSize != newSize || _gameSize == null) {
      _screenSize = newSize;
      _updateSizes();

      return true;
    }

    return false;
  }

  static String _valueChangedString(
    double oldValue,
    double newValue,
    String name,
  ) {
    return '\t'
        '$name (from ${oldValue.toStringAsFixed(2)}, '
        'to ${newValue.toStringAsFixed(2)})';
  }
}
