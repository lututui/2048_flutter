import 'package:flutter/material.dart';
import 'package:flutter_2048/widgets/tile_loading_indicator.dart';

/// The main [PageRouteBuilder] for this app
class MainMenuRouteBuilder extends PageRouteBuilder {
  /// Creates a route to the widget built by [pageBuilder]
  MainMenuRouteBuilder({
    @required WidgetBuilder pageBuilder,
  }) : super(
          pageBuilder: (context, _, __) => pageBuilder(context),
          transitionDuration: const Duration(seconds: 2),
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> inAnimation,
    Animation<double> outAnimation,
    Widget child,
  ) {
    final ProxyAnimation proxyAnimation = inAnimation as ProxyAnimation;

    if (proxyAnimation.parent == kAlwaysCompleteAnimation) {
      return Container();
    }

    if (proxyAnimation.isCompleted) {
      return child;
    }

    return Stack(
      children: <Widget>[
        if (proxyAnimation.value > 0.5) child,
        FadeTransition(
          opacity: TweenSequence<double>([
            TweenSequenceItem(
              tween: CurveTween(curve: Curves.easeInOut),
              weight: 0.5,
            ),
            TweenSequenceItem(
              tween: Tween(begin: 1.0, end: 0.0).chain(
                CurveTween(curve: Curves.easeInOut),
              ),
              weight: 0.5,
            ),
          ]).animate(proxyAnimation),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TileLoadingIndicator.fromBoxConstraints(
              BoxConstraints.tight(MediaQuery.of(context).size),
              proxyAnimation,
            ),
          ),
        ),
      ],
    );
  }
}
