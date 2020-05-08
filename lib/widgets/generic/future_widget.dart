import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';

typedef OnErrorCallback = void Function(Object);
typedef ComputationCallback<T> = FutureOr<T> Function();

class FutureWidget<T> extends StatelessWidget {
  FutureWidget({
    @required this.computation,
    @required this.loadingChild,
    @required this.onError,
    @required this.builder,
    this.errorChild,
    Key key,
  }) : super(key: key);

  final AsyncMemoizer<T> _memoizer = AsyncMemoizer();
  final AsyncWidgetBuilder<T> builder;
  final ComputationCallback<T> computation;
  final OnErrorCallback onError;
  final Widget loadingChild;
  final Widget errorChild;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _memoizer.runOnce(computation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadingChild;
        }

        if (snapshot.hasError || !snapshot.hasData) {
          onError(snapshot.error);

          return errorChild ?? ErrorWidget(snapshot.error);
        }

        return builder(context, snapshot);
      },
    );
  }
}
