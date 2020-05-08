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
      elevation: 0.0,
      onPressed: () => Navigator.of(context).pushNamed(routeName),
      child: Text(buttonText, style: const TextStyle(fontSize: 16.0)),
    );
  }
}
