import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/types/callbacks.dart';

class FutureWidget<T> extends StatelessWidget {
  final AsyncMemoizer<T> _memoizer = AsyncMemoizer();
  final WidgetContextSnapshotCallback<T> builder;
  final FutureOrCallback<T> computation;
  final VoidObjectCallback onError;
  final Widget loadingChild;
  final Widget errorChild;

  FutureWidget({
    Key key,
    @required this.computation,
    @required this.loadingChild,
    @required this.onError,
    @required this.builder,
    this.errorChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _memoizer.runOnce(this.computation),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return this.loadingChild;
        }

        if (snapshot.hasError || !snapshot.hasData) {
          this.onError(snapshot.error);

          return this.errorChild;
        }

        return this.builder(context, snapshot);
      },
    );
  }
}
