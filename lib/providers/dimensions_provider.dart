import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/types/size_options.dart';

/// Calculates and provides the dimensions for the main game screen
class DimensionsProvider with ChangeNotifier, WidgetsBindingObserver {
  /// Provides the singleton instance for this provider
  factory DimensionsProvider() => instance ??= DimensionsProvider._();

  DimensionsProvider._() {
    WidgetsBinding.instance.addObserver(this);

    _selectedSizeOption = kDefaultSizeOption;

    _updateScreenSize();
  }

  /// The singleton instance
  ///
  /// Use only where you must not listen to change notifications
  static DimensionsProvider instance;

  Size _screenSize;
  double _tileSize;
  double _gapSize;
  double _gameSize;
  SizeOption _selectedSizeOption;

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
  SizeOption get selectedSizeOption => _selectedSizeOption;

  /// Setter for [selectedSizeOption]
  void selectSizeOption(int index) {
    if (index == _selectedSizeOption.index) return;

    _selectedSizeOption = SizeOption.withIndex(index);

    _log('Changed gridSize to $_selectedSizeOption');

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
    final double newTileSize = min(_screenSize.width, _screenSize.height) /
        (_selectedSizeOption.sideLength + 2);
    final double newGapSize =
        newTileSize / (2.0 * _selectedSizeOption.sideLength);
    final double newGameSize =
        _selectedSizeOption.sideLength * (newTileSize + newGapSize) +
            newGapSize;

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

  void _updateScreenSize() {
    final newSize = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;

    if (_screenSize != newSize || _gameSize == null) {
      _screenSize = newSize;
      _updateSizes();
    }
  }

  static String _valueChangedString(
    double oldValue,
    double newValue,
    String name,
  ) {
    return '\t$name (from ${oldValue.toStringAsFixed(2)}, '
        'to ${newValue.toStringAsFixed(2)})';
  }
}
