import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:provider/provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, scoreText) {
        return Container(
          width: dimensions.gameSize.width + dimensions.gapSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BorderedBox(
                borderWidth: dimensions.gapSize.width / 2,
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Score',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BorderedBox(
                borderWidth: dimensions.gapSize.width / 2,
                padding: const EdgeInsets.all(2.0),
                child: scoreText,
              ),
            ],
          ),
        );
      },
      child: Consumer<GridProvider>(
        builder: (context, grid, _) {
          return Text(
            '${grid.score}',
            maxLines: 1,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.headline6,
          );
        },
      ),
    );
  }
}
