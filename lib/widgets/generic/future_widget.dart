import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnErrorCallback = void Function(Object);
typedef ComputationCallback<T> = FutureOr<T> Function();

/// A nicer wrapper for [FutureBuilder]
class FutureWidget<T> extends StatelessWidget {
  /// Creates a new future widget
  FutureWidget({
    @required this.computation,
    @required this.loadingChild,
    @required this.builder,
    this.onError,
    this.errorChild,
    Key key,
  }) : super(key: key);

  final AsyncMemoizer<T> _memoizer = AsyncMemoizer();

  /// The widget to build when [computation] completes successfully
  final AsyncWidgetBuilder<T> builder;

  /// The async computation to be run
  final ComputationCallback<T> computation;

  /// Called when [computation] completes with an error
  final OnErrorCallback onError;

  /// The widget to build while [computation] is running
  final WidgetBuilder loadingChild;

  /// The widget to build when [computation] completes with an error
  ///
  /// Only called if [onError] is non-null
  /// If [onError] is non-null and this is null, [ErrorWidget] will be used to
  /// display the error
  final WidgetBuilder errorChild;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _memoizer.runOnce(computation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadingChild(context);
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (onError == null) {
            throw snapshot.error;
          } else {
            onError.call(snapshot.error);
          }

          return errorChild?.call(context) ?? ErrorWidget(snapshot.error);
        }

        return builder(context, snapshot);
      },
    );
  }
}
