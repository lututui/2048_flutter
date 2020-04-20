import 'package:flutter/material.dart';
import 'package:flutter_2048/util/fonts.dart';

class FixedWidthText extends StatelessWidget {
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
    maxLines: 1,
  );

  FixedWidthText({
    Key key,
    @required String text,
    @required double width,
  }) : super(key: key) {
    this.textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: Fonts.RIGHTEOUS_FAMILY,
        fontSize: 16.0,
      ),
    );

    this.textPainter.layout(minWidth: width, maxWidth: width);
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
