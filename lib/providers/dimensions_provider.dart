import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';

/// Calculates and provides the dimensions for the main game screen
class DimensionsProvider with ChangeNotifier, WidgetsBindingObserver {
  /// Provides the singleton instance for this provider
  factory DimensionsProvider() => _instance ??= DimensionsProvider._();

  DimensionsProvider._() {
    WidgetsBinding.instance.addObserver(this);

    _updateScreenSize();
  }

  static DimensionsProvider _instance;

  static const int _defaultGridSize = 4;

  Size _screenSize;
  double _tileSize;
  double _gapSize;
  double _gameSize;
  int _gridSize;

  void _log(String message) {
    Logger.log<DimensionsProvider>(message);
  }

  /// The space between two tiles
  double get gapSize => _gapSize;

  /// The space taken by the game
  double get gameSize => _gameSize;

  /// The space taken by a game tile
  double get tileSize => _tileSize;

  /// The current grid size
  int get gridSize => _gridSize ??= _defaultGridSize;

  set gridSize(int value) {
    _gridSize = value;

    _log('Changed gridSize to $_gridSize');

    if (_screenSize != null) {
      _log('Updating other sizes');
      _updateSizes();
    } else {
      notifyListeners();
    }
  }

  @override
  void didChangeMetrics() => _updateScreenSize;

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
      _log(
        'Triggered a notification to listeners.\n'
        '${stringBuilder.join(',\n')}',
      );

      notifyListeners();
    }
  }

  bool _updateScreenSize() {
    final newSize = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;

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
