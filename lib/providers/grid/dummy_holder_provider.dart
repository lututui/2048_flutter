import 'package:flutter/cupertino.dart';
import 'package:flutter_2048/providers/grid/dummy_grid_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:provider/provider.dart';

class DummyHolderProvider {
  final List<DummyGridProvider> providers = List(SizeOptions.SIZES.length);

  DummyHolderProvider();

  factory DummyHolderProvider.of(BuildContext context) {
    return Provider.of<DummyHolderProvider>(context, listen: false);
  }
}
