import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/dummy_grid_provider.dart';
import 'package:flutter_2048/providers/grid/dummy_holder_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:provider/provider.dart';

class DummyGame extends StatelessWidget {
  DummyGame(BuildContext context, {Key key}) : super(key: key) {
    final DummyHolderProvider providerHolder = DummyHolderProvider.of(
      context,
    );
    final DimensionsProvider dimensions = DimensionsProvider.of(
      context,
      listen: false,
    );
    final int index = SizeOptions.getSizeIndexBySideLength(dimensions.gridSize);

    if (providerHolder.providers[index] == null) {
      providerHolder.providers[index] = DummyGridProvider(context);
      providerHolder.providers[index].spawn(
        amount: Data.rand.nextIntRanged(
          min: providerHolder.providers[index].grid.sideLength,
          max: providerHolder.providers[index].grid.flattenLength,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int index = SizeOptions.getSizeIndexBySideLength(
      DimensionsProvider.of(context).gridSize,
    );

    final DummyHolderProvider providerHolder = DummyHolderProvider.of(context);

    if (providerHolder.providers[index] == null) {
      providerHolder.providers[index] = DummyGridProvider(context);
      providerHolder.providers[index].spawn(
        amount: Data.rand.nextIntRanged(
          min: providerHolder.providers[index].grid.sideLength,
          max: providerHolder.providers[index].grid.flattenLength,
        ),
      );
    }

    final Size predictedMaxSize = Sizes.scale(
      DimensionsProvider.calculateSizes(
        MediaQuery.of(context).size,
        SizeOptions.SIZES.first.sideLength,
      )["game"],
      factor: 0.7,
    );

    return Provider.value(
      value: providerHolder.providers[index],
      child: Container(
        width: predictedMaxSize.width,
        height: predictedMaxSize.height,
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: const GameGrid<DummyGridProvider>(),
        ),
      ),
    );
  }
}
