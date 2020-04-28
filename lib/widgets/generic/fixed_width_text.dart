import 'package:flutter/material.dart';

class FixedWidthText extends StatelessWidget {
  final TextPainter textPainter = TextPainter();

  FixedWidthText({
    Key key,
    @required InlineSpan inlineSpan,
    @required num width,
    TextDirection textDirection = TextDirection.ltr,
    TextAlign textAlign = TextAlign.center,
    int maxLines = 1,
  }) : super(key: key) {
    ArgumentError.checkNotNull(inlineSpan, 'inlineSpan');
    ArgumentError.checkNotNull(width, 'width');

    this.textPainter
      ..textDirection = textDirection ?? TextDirection.ltr
      ..textAlign = textAlign ?? TextAlign.center
      ..maxLines = maxLines ?? 1
      ..text = inlineSpan
      ..layout(minWidth: width, maxWidth: width);
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
