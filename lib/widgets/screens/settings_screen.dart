import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/widgets/switch_setting_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Appearance",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Divider(
                  height: 8.0,
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, _) {
                return SwitchSettingWidget(
                  text: "Dark mode",
                  value: settings.darkMode,
                  onChangedCallback: (newValue) => settings.darkMode = newValue,
                );
              },
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text("Game palette"),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/palette_picker');
                        },
                        child: Row(
                          children: <Widget>[
                            Text(settings.palette.name),
                            const Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
