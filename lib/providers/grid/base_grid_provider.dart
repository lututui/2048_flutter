import 'package:flutter/material.dart';
import 'package:flutter_2048/util/tile_grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:provider/provider.dart';

abstract class BaseGridProvider {
  final List<Widget> tiles = List();
  TileGrid _grid;

  BaseGridProvider(this._grid);

  BaseGridProvider.empty();

  TileGrid get grid => _grid;

  set grid(TileGrid value) {
    _grid = value;

    print("Setting tilegrid to $value");
  }

  factory BaseGridProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<BaseGridProvider>(context, listen: listen);
  }

  void spawn({int amount = 1}) {
    if (_grid.spawnableSpaces < amount) {
      throw Exception(
        "Tried to spawn $amount but only ${_grid.spawnableSpaces} spaces are available",
      );
    }

    for (int i = 0; i < amount; i++)
      this.spawnAt(_grid.getRandomSpawnableSpace());
  }

  void spawnAt(Tuple<int, int> pos, {int value});
}