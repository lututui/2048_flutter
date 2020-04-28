import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile/base_tile_provider.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:provider/provider.dart';

class TileProvider extends BaseTileProvider with ChangeNotifier {
  bool pendingValueUpdate = false;
  bool moving = false;

  TileProvider._(Tuple<int, int> pos, int value) : super(pos, value);

  factory TileProvider(Tuple<int, int> pos, {int value}) {
    return TileProvider._(
      pos,
      value ?? Data.pickSpawnValue(),
    );
  }

  factory TileProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<TileProvider>(context, listen: listen);
  }

  set value(int value) {
    if (this.value == value) return;

    super.value = value;
    notifyListeners();
  }

  set gridPos(Tuple<int, int> value) {
    if (this.gridPos == value) return;

    Logger.log<TileProvider>(
      "Setting tile pos as $value (was $gridPos)",
      instance: this,
    );

    super.gridPos = value;
    moving = true;
    notifyListeners();
  }

  void onMoveEnd() {
    Logger.log<TileProvider>("Done moving", instance: this);
    moving = false;

    if (this.pendingValueUpdate) updateValue();
  }

  void updateValue() {
    this.pendingValueUpdate = false;
    this.value++;
  }

  bool compareValue(Object other) {
    return other is TileProvider && this.value == other.value;
  }
}
