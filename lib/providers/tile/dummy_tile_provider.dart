import 'package:flutter_2048/providers/tile/base_tile_provider.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';

class DummyTileProvider extends BaseTileProvider {
  DummyTileProvider._(
    Tuple<int, int> gridPos,
    int value,
  ) : super(gridPos, value);

  factory DummyTileProvider(Tuple<int, int> pos, {int value}) {
    return DummyTileProvider._(
      pos,
      value ?? Data.pickSpawnValue(),
    );
  }
}
