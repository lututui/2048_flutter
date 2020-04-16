import 'package:flutter/material.dart';
import 'package:flutter_2048/util/fonts.dart';

class FixedWidthText extends StatelessWidget {
  final TextPainter textPainter;

  const FixedWidthText._({Key key, this.textPainter}) : super(key: key);

  factory FixedWidthText({
    Key key,
    @required String text,
    @required double width,
  }) {
    final TextPainter tPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: Fonts.RIGHTEOUS_FAMILY,
          fontSize: 16.0,
        ),
      ),
    );

    tPainter.layout(minWidth: width, maxWidth: width);

    return FixedWidthText._(key: key, textPainter: tPainter);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FixedWidthTextPainter(this.textPainter),
    );
  }
}

class _FixedWidthTextPainter extends CustomPainter {
  final TextPainter painter;

  const _FixedWidthTextPainter(this.painter);

  @override
  void paint(Canvas canvas, Size size) {
    painter.paint(canvas, Offset(painter.width, painter.height) * (-1 / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
