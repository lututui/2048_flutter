import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/widgets/tiles/unplaced_tile.dart';
import 'package:provider/provider.dart';

class ImmovableTile extends StatelessWidget {
  final int value;
  final Tuple<int, int> gridPos;

  const ImmovableTile({
    Key key,
    @required this.value,
    @required this.gridPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, child) {
        final double xPos = this.gridPos.b *
                (dimensions.gapSize.width + dimensions.tileSize.width) +
            dimensions.gapSize.width;
        final double yPos = this.gridPos.a *
                (dimensions.gapSize.height + dimensions.tileSize.height) +
            dimensions.gapSize.height;

        return Positioned(
          left: xPos,
          top: yPos,
          child: Consumer<SettingsProvider>(
            builder: (context, settings, _) {
              return UnplacedTile(
                color: settings.palette.getTileColor(this.value),
                borderWidth: dimensions.gapSize.width / 2.0,
                height: dimensions.tileSize.height,
                width: dimensions.tileSize.width,
                text: "${1 << this.value}",
              );
            },
          ),
        );
      },
    );
  }
}
