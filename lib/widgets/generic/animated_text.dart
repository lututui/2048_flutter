import 'package:flutter/material.dart';

/// A widget that implicitly animates between two texts
class AnimatedText extends StatefulWidget {
  /// Creates a new animated text widget
  ///
  /// [tweenBuilder] is a function that returns a tween to animate [text]
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

  /// Function to build the tween between two texts
  final Tween<String> Function({String begin, String end}) tweenBuilder;

  /// Animation duration
  final Duration duration;

  /// Animation end callback
  final VoidCallback onEnd;

  /// Animation curve
  final Curve curve;

  /// See [Text.data]
  final String text;

  /// See [Text.style]
  final TextStyle textStyle;

  /// See [Text.strutStyle]
  final StrutStyle strutStyle;

  /// See [Text.textAlign]
  final TextAlign textAlign;

  /// See [Text.textDirection]
  final TextDirection textDirection;

  /// See [Text.locale]
  final Locale locale;

  /// See [Text.softWrap]
  final bool softWrap;

  /// See [Text.overflow]
  final TextOverflow overflow;

  /// See [Text.textScaleFactor]
  final double textScaleFactor;

  /// See [Text.maxLines]
  final int maxLines;

  /// See [Text.semanticsLabel]
  final String semanticsLabel;

  /// See [Text.textWidthBasis]
  final TextWidthBasis textWidthBasis;

  /// See [Text.textHeightBehavior]
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
      builder: (context, value, _) {
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
