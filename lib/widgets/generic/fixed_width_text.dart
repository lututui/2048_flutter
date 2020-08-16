import 'package:flutter/material.dart';

/// A text widget that layouts [inlineSpan] with fixed width
class FixedWidthText extends StatelessWidget {
  /// Creates a new fixed width text widget
  FixedWidthText({
    @required InlineSpan inlineSpan,
    @required double width,
    TextDirection textDirection = TextDirection.ltr,
    TextAlign textAlign = TextAlign.center,
    int maxLines = 1,
    Key key,
  })  : _maxWidth = width,
        super(key: key) {
    ArgumentError.checkNotNull(inlineSpan, 'inlineSpan');

    _textPainter
      ..textDirection = textDirection ?? TextDirection.ltr
      ..textAlign = textAlign ?? TextAlign.center
      ..maxLines = maxLines ?? 1
      ..text = inlineSpan
      ..layout(minWidth: width);
  }

  final TextPainter _textPainter = TextPainter();
  final double _maxWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FixedWidthTextPainter(_textPainter, _maxWidth),
    );
  }
}

class _FixedWidthTextPainter extends CustomPainter {
  const _FixedWidthTextPainter(this.painter, this.maxWidth);

  final TextPainter painter;
  final double maxWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (maxWidth == 0) return;

    canvas.scale(1 - (painter.width - maxWidth) / maxWidth);
    painter.paint(
      canvas,
      Offset(painter.width, painter.height).scale(-0.5, -0.5),
    );
  }

  @override
  bool shouldRepaint(_FixedWidthTextPainter oldDelegate) {
    return oldDelegate.painter.text != painter.text ||
        oldDelegate.painter.textDirection != painter.textDirection ||
        oldDelegate.painter.textAlign != painter.textAlign ||
        oldDelegate.painter.maxLines != painter.maxLines ||
        oldDelegate.maxWidth != maxWidth ||
        oldDelegate.painter.width != painter.width;
  }
}
