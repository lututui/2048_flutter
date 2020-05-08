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
      child: Consumer<GridProvider>(
        builder: (context, grid, _) {
          return Text(
            "${grid.score}",
            maxLines: 1,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 20),
          );
        },
      ),
      builder: (context, dimensions, scoreText) {
        return Container(
          width: dimensions.gameSize.width + dimensions.gapSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BorderedBox(
                child: const Text(
                  "Score",
                  style: const TextStyle(fontSize: 20),
                ),
                borderWidth: dimensions.gapSize.width / 2,
                padding: const EdgeInsets.all(2.0),
              ),
              BorderedBox(
                child: scoreText,
                borderWidth: dimensions.gapSize.width / 2,
                padding: const EdgeInsets.all(2.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
