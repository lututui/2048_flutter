import 'package:flutter/material.dart';

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
    return RaisedButton(
      elevation: 0.0,
      onPressed: () => Navigator.of(context).pushNamed(this.routeName),
      child: Text(
        this.buttonText,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
