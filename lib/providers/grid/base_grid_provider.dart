import 'package:flutter/material.dart';
import 'package:flutter_2048/util/grid.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:provider/provider.dart';

abstract class BaseGridProvider {
  final List<Widget> tiles = List();
  Grid get grid;

  BaseGridProvider();

  factory BaseGridProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<BaseGridProvider>(context, listen: listen);
  }

  void spawn({int amount = 1}) {
    if (grid.spawnableSpaces < amount) {
      throw Exception(
        "Tried to spawn $amount but only ${grid.spawnableSpaces} spaces are available",
      );
    }

    for (int i = 0; i < amount; i++)
      this.spawnAt(grid.getRandomSpawnableSpace());
  }

  void spawnAt(Tuple<int, int> pos, {int value});
}
