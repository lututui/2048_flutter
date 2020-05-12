import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/widgets/generic/theme_switch.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      title: const Text('Settings'),
      primary: false,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          appBar.preferredSize.width,
          appBar.preferredSize.height - MediaQuery.of(context).padding.top,
        ),
        child: appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(
                  height: 8.0,
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Dark mode',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Consumer<SettingsProvider>(
                        builder: (context, settings, _) {
                          return ThemeSwitch(
                            value: settings.darkMode,
                            onChanged: (value) => settings.darkMode = value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Game palette',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/palette_picker');
                        },
                        child: Row(
                          children: <Widget>[
                            Consumer<SettingsProvider>(
                              builder: (context, settings, _) {
                                return Text(settings.palette.name);
                              },
                            ),
                            const Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Gameplay',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(
                  height: 8.0,
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Save only unfinished games',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Consumer<SettingsProvider>(
                        builder: (context, settings, _) {
                          return ThemeSwitch(
                            value: settings.autoReset,
                            onChanged: (v) => settings.autoReset = v,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
