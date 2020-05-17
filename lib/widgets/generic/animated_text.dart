import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({
    @required this.text,
    @required this.tweenBuilder,
    @required this.textStyle,
    this.duration = const Duration(milliseconds: 500),
    this.onEnd,
    this.curve = Curves.linear,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    Key key,
  }) : super(key: key);

  final Tween<String> Function({String begin, String end}) tweenBuilder;
  final Duration duration;
  final VoidCallback onEnd;
  final Curve curve;

  final String text;
  final TextStyle textStyle;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  Tween<String> _textTween;

  @override
  void initState() {
    _textTween = widget.tweenBuilder(begin: widget.text, end: widget.text);

    super.initState();
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text) {
      _textTween = widget.tweenBuilder(begin: oldWidget.text, end: widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<String>(
      tween: _textTween,
      curve: widget.curve,
      duration: widget.duration,
      onEnd: widget.onEnd,
      builder: (context, value, child) {
        return Text(
          value,
          style: widget.textStyle,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          locale: widget.locale,
          softWrap: widget.softWrap,
          overflow: widget.overflow,
          textScaleFactor: widget.textScaleFactor,
          maxLines: widget.maxLines,
          semanticsLabel: widget.semanticsLabel,
          textWidthBasis: widget.textWidthBasis,
          textHeightBehavior: widget.textHeightBehavior,
        );
      },
    );
  }
}
