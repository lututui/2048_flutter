import 'package:flutter/material.dart';
import 'package:flutter_2048/util/palette.dart';

class MainMenuButton extends StatelessWidget {
  final String routeName;
  final String buttonText;

  const MainMenuButton({
    Key key,
    @required this.routeName,
    @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(this.routeName),
        color: Palette.MAIN_MENU_BUTTON_BACKGROUND_COLOR,
        shape: const Border.fromBorderSide(
          const BorderSide(
            width: 2.0,
            color: Palette.MAIN_MENU_BUTTON_BORDER_COLOR,
          ),
        ),
        child: Text(
          this.buttonText,
          style: const TextStyle(
            color: Palette.MAIN_MENU_BUTTON_TEXT_COLOR,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
