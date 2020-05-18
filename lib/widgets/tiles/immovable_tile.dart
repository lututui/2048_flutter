import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/widgets/tiles/unplaced_tile.dart';
import 'package:provider/provider.dart';

class ImmovableTile extends StatelessWidget {
  const ImmovableTile({
    @required this.value,
    @required this.gridPos,
    Key key,
  }) : super(key: key);

  final int value;
  final Tuple<int, int> gridPos;

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, child) {
        final double gapSize = dimensions.getGapSize(context);
        final double tileSize = dimensions.getTileSize(context);

        final double xPos = gridPos.b * (gapSize + tileSize) + gapSize;
        final double yPos = gridPos.a * (gapSize + tileSize) + gapSize;

        return Positioned(
          left: xPos,
          top: yPos,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return UnplacedTile(
                animate: false,
                color: settings.palette.getTileColor(value),
                borderSize: gapSize / 2.0,
                size: tileSize,
                text: '${1 << value}',
              );
            },
          ),
        );
      },
    );
  }
}
