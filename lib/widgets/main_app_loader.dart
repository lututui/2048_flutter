import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/generic/future_widget.dart';
import 'package:flutter_2048/widgets/main_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A widget that shows a loading indicator while running
/// [SharedPreferences.getInstance] and, when done, shows [MainApp]
class MainAppLoader extends StatelessWidget {
  /// Creates a new loader widget
  const MainAppLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureWidget<SharedPreferences>(
      computation: () => SharedPreferences.getInstance(),
      loadingChild: (context) {
        return Misc.buildDefaultMaterialApp(
          context,
          childBuilder: Misc.buildDefaultMaterialApp,
        );
      },
      builder: (context, snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingsProvider>.value(
              value: SettingsProvider.load(snapshot.data),
            ),
            ChangeNotifierProvider<DimensionsProvider>.value(
              value: DimensionsProvider(),
            ),
          ],
          child: const MainApp(),
        );
      },
    );
  }
}
