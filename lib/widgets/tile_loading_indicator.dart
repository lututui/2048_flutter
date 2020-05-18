import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/types/tile_color.dart';
import 'package:flutter_2048/widgets/tiles/unplaced_tile.dart';

class TileLoadingIndicator extends StatelessWidget {
  const TileLoadingIndicator({
    @required this.constraint,
    this.customController,
    Key key,
  }) : super(key: key);

  factory TileLoadingIndicator.fromBoxConstraints(
    BoxConstraints constraints, [
    ProxyAnimation customController,
  ]) {
    final double minMaxBox = min(constraints.maxHeight, constraints.maxWidth);
    final double maxMinBox = max(constraints.minHeight, constraints.minWidth);

    if ((minMaxBox <= 0.0 && maxMinBox <= 0.0) ||
        (minMaxBox.isInfinite && maxMinBox.isInfinite)) {
      throw Exception('Invalid constraints. $constraints');
    }

    return TileLoadingIndicator(
      customController: customController,
      constraint: minMaxBox.isInfinite ? maxMinBox : minMaxBox,
    );
  }

  final double constraint;
  final ProxyAnimation customController;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Duration duration = (customController == null)
        ? const Duration(seconds: 2)
        : (customController.parent as AnimationController).duration;

    return Center(
      child: Container(
        width: constraint,
        height: constraint,
        alignment: Alignment.center,
        child: _LoadingAnimation(
          constraint: constraint / (2 * sqrt(2)),
          duration: duration,
          color: TileColor(colorScheme.surface, colorScheme.onSurface),
          customController: customController,
        ),
      ),
    );
  }
}

class _LoadingAnimation extends StatefulWidget {
  factory _LoadingAnimation({
    @required double constraint,
    @required Duration duration,
    @required TileColor color,
    ProxyAnimation customController,
  }) {
    return _LoadingAnimation._(
      constraint: constraint,
      duration: duration,
      animatable: _buildAnimatableSequence(customController?.status),
      tileColor: color,
      customController: customController,
    );
  }

  const _LoadingAnimation._({
    this.constraint,
    this.duration,
    this.animatable,
    this.tileColor,
    this.customController,
    Key key,
  }) : super(key: key);

  final double constraint;
  final Duration duration;
  final TileColor tileColor;
  final TweenSequence<double> animatable;
  final ProxyAnimation customController;

  static TweenSequence<double> _buildAnimatableSequence([
    AnimationStatus status,
  ]) {
    return TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 2 * pi).chain(
          CurveTween(
            curve: (status == AnimationStatus.reverse)
                ? Curves.fastOutSlowIn.flipped
                : Curves.fastOutSlowIn,
          ),
        ),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 0.5,
      ),
    ]);
  }

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<_LoadingAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    if (widget.customController == null) {
      _controller = AnimationController(vsync: this, duration: widget.duration);
      _animation = widget.animatable.animate(_controller..repeat());
    } else {
      _animation = widget.animatable.animate(widget.customController);
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.customController == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value, child: child);
      },
      child: UnplacedTile(
        animate: false,
        color: widget.tileColor,
        borderSize: widget.constraint / 16,
        size: widget.constraint,
        text: '2048',
      ),
    );
  }
}
