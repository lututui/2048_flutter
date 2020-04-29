import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

typedef BuildPageCallback = Widget Function(BuildContext);

class MainMenuRouteBuilder<T> extends PageRouteBuilder<T> {
  MainMenuRouteBuilder({
    BuildPageCallback pageBuilder,
    DimensionsProvider dimensionsProvider,
  }) : super(
          pageBuilder: (context, _, __) {
            if (dimensionsProvider == null) {
              return pageBuilder(context);
            }

            final List<SingleChildWidget> providers = <SingleChildWidget>[
              (dimensionsProvider != null)
                  ? ChangeNotifierProvider.value(value: dimensionsProvider)
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
