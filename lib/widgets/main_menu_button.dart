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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 0.0),
      child: RaisedButton(
        onPressed: () => Navigator.of(context).pushNamed(routeName),
        child: Text(buttonText),
      ),
    );
  }
}
