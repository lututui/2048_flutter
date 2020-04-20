import 'package:flutter/material.dart';
import 'package:flutter_2048/types/void_callback.dart';
import 'package:flutter_2048/util/palette.dart';

class DialogOption extends StatelessWidget {
  final Color color;
  final VoidContextCallback callback;
  final IconData icon;
  final double width;
  final double height;

  const DialogOption({
    Key key,
    @required this.color,
    @required this.callback,
    @required this.icon,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: this.width,
        height: this.height,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: this.color,
          border: Border.fromBorderSide(
            BorderSide(
              color: Palette.darkenColor(this.color),
              width: 3.0,
            ),
          ),
        ),
        child: IconButton(
          icon: Icon(this.icon),
          onPressed: () => this.callback(context),
        ),
      ),
    );
  }
}
