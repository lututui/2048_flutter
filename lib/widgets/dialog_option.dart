import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/callbacks.dart';
import 'package:flutter_2048/util/palette.dart';

class DialogOption extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final VoidContextCallback callback;
  final IconData icon;

  DialogOption.square({
    Key key,
    @required this.color,
    @required this.callback,
    @required this.icon,
    Color borderColor,
  })  : borderColor = borderColor ?? Palette.darkenColor(color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);

    return Container(
      width: dimensions.tileSize.width,
      height: dimensions.tileSize.height,
      decoration: BoxDecoration(
        color: this.color,
        border: Border.fromBorderSide(
          BorderSide(
            color: this.borderColor,
            width: 3.0,
          ),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          padding: const EdgeInsets.all(8.0),
          icon: LayoutBuilder(
            builder: (context, constraints) {
              return Icon(
                this.icon,
                size: min(constraints.maxHeight, constraints.maxWidth),
              );
            },
          ),
          onPressed: () => this.callback(context),
        ),
      ),
    );
  }
}
