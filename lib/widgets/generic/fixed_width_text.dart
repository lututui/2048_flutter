import 'package:flutter/material.dart';

/// A text widget that layouts [inlineSpan] with fixed width
class FixedWidthText extends StatelessWidget {
  /// Creates a new fixed width text widget
  ///
  /// [width] should be equal to or larger than the width of the
  /// unconstrained [inlineSpan]
  FixedWidthText({
    @required InlineSpan inlineSpan,
    @required num width,
    TextDirection textDirection = TextDirection.ltr,
    TextAlign textAlign = TextAlign.center,
    int maxLines = 1,
    Key key,
  }) : super(key: key) {
    ArgumentError.checkNotNull(inlineSpan, 'inlineSpan');
    ArgumentError.checkNotNull(width, 'width');

    _textPainter
      ..textDirection = textDirection ?? TextDirection.ltr
      ..textAlign = textAlign ?? TextAlign.center
      ..maxLines = maxLines ?? 1
      ..text = inlineSpan
      ..layout(minWidth: width.toDouble(), maxWidth: width.toDouble());
  }

  final TextPainter _textPainter = TextPainter();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FixedWidthTextPainter(_textPainter));
  }
}

class _FixedWidthTextPainter extends CustomPainter {
  const _FixedWidthTextPainter(this.painter);

  final TextPainter painter;

  @override
  void paint(Canvas canvas, Size size) {
    painter.paint(canvas, Offset(painter.width, painter.height) * (-1 / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
