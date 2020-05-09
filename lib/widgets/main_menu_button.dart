import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({
    @required this.routeName,
    @required this.buttonText,
    Key key,
  }) : super(key: key);

  final String routeName;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => Navigator.of(context).pushNamed(routeName),
      child: Text(buttonText),
    );
  }
}
