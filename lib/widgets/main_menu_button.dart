import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final String routeName;
  final Object routeArgs;
  final String buttonText;

  const MainMenuButton({
    Key key,
    @required this.routeName,
    this.routeArgs,
    @required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () => Navigator.of(context).pushNamed(
        this.routeName,
        arguments: routeArgs,
      ),
      color: Colors.transparent,
      child: Text(
        this.buttonText,
        style: const TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
