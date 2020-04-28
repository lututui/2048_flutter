import 'dart:async';

import 'package:flutter/widgets.dart';

typedef VoidCallback = void Function();
typedef VoidIntCallback = void Function(int);
typedef VoidContextCallback = void Function(BuildContext);
typedef VoidObjectCallback = void Function(Object);

typedef WidgetContextCallback = Widget Function(BuildContext);
typedef WidgetContextSnapshotCallback<T> = Widget Function(
  BuildContext,
  AsyncSnapshot<T>,
);

typedef FutureOrCallback<T> = FutureOr<T> Function();
