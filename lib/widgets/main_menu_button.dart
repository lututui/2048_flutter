import 'package:flutter/material.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';

/// A button to be shown in [MainMenuScreen]
class MainMenuButton extends StatelessWidget {
  /// Creates a new button
  const MainMenuButton({
    @required this.routeName,
    @required this.buttonText,
    Key key,
  }) : super(key: key);

  /// The route name to navigate to when this is pressed
  final String routeName;

  /// The text to be shown in the button
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(routeName),
        child: Text(buttonText),
      ),
    );
  }
}
