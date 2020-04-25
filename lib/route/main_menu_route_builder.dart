import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/dummy_holder_provider.dart';
import 'package:flutter_2048/types/callbacks.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MainMenuRouteBuilder<T> extends PageRouteBuilder<T> {
  MainMenuRouteBuilder({
    WidgetContextCallback pageBuilder,
    DimensionsProvider dimensionsProvider,
    DummyHolderProvider dummyHolderProvider,
  }) : super(
          pageBuilder: (context, _, __) {
            if (dimensionsProvider == null && dummyHolderProvider == null) {
              return pageBuilder(context);
            }

            final List<SingleChildWidget> providers = <SingleChildWidget>[
              (dimensionsProvider != null)
                  ? ChangeNotifierProvider.value(value: dimensionsProvider)
                  : null,
              (dummyHolderProvider != null)
                  ? Provider.value(value: dummyHolderProvider)
                  : null,
            ].where((it) => it != null).toList();

            return MultiProvider(
              providers: providers,
              child: Builder(
                builder: (context) {
                  dimensionsProvider?.updateScreenSize(context);
                  return pageBuilder(context);
                },
              ),
            );
          },
        );
}
