import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef OnErrorCallback = void Function(Object);
typedef ComputationCallback<T> = FutureOr<T> Function();

class FutureWidget<T> extends StatelessWidget {
  FutureWidget({
    @required this.computation,
    @required this.loadingChild,
    @required this.builder,
    this.onError,
    this.errorChild,
    Key key,
  }) : super(key: key);

  final AsyncMemoizer<T> _memoizer = AsyncMemoizer();
  final AsyncWidgetBuilder<T> builder;
  final ComputationCallback<T> computation;
  final OnErrorCallback onError;
  final WidgetBuilder loadingChild;
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
