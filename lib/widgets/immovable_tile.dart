import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/tile/dummy_tile_provider.dart';
import 'package:flutter_2048/providers/tile/tile_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:flutter_2048/widgets/fixed_width_text.dart';

class ImmovableTile extends StatelessWidget {
  final Offset topLeft;
  final Color color;
  final Color borderColor;
  final int value;

  const ImmovableTile._({
    Key key,
    @required this.topLeft,
    @required this.color,
    @required this.borderColor,
    @required this.value,
  }) : super(key: key);

  factory ImmovableTile(
    DummyTileProvider dummyTileProvider,
    BuildContext context, {
    Key key,
  }) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);

    return ImmovableTile._(
      key: key,
      topLeft: Offset(
        dummyTileProvider.gridPos.b * dimensions.gapSize.width +
            dummyTileProvider.gridPos.b * dimensions.tileSize.width +
            dimensions.gapSize.width,
        dummyTileProvider.gridPos.a * dimensions.gapSize.height +
            dummyTileProvider.gridPos.a * dimensions.tileSize.height +
            dimensions.gapSize.height,
      ),
      color: Palette.getTileColor(dummyTileProvider.value),
      borderColor: Palette.getTileBorder(dummyTileProvider.value),
      value: 1 << dummyTileProvider.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = DimensionsProvider.of(context);

    return Positioned(
      left: this.topLeft.dx,
      top: this.topLeft.dy,
      child: Container(
        decoration: BoxDecoration(
          color: this.color,
          border: Border.fromBorderSide(
            BorderSide(
              color: this.borderColor,
              width: dimensions.gapSize.width / 2,
            ),
          ),
        ),
        height: dimensions.tileSize.height,
        width: dimensions.tileSize.width,
        alignment: Alignment.center,
        child: FixedWidthText(
          text: this.value.toString(),
          width: dimensions.tileSize.width,
        ),
      ),
    );
  }
}
