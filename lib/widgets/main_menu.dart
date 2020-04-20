import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              onPressed: () => Navigator.of(context).pushNamed('/game4x4'),
              color: Colors.transparent,
              borderSide: const BorderSide(style: BorderStyle.none),
              child: const Text(
                "Play",
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 16.0,
                ),
              ),
            ),
            OutlineButton(
              onPressed: () => Navigator.of(context).pushNamed("/leaderboard4"),
              color: Colors.transparent,
              borderSide: const BorderSide(style: BorderStyle.none),
                child: const Text(
                  "Leaderboard",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 16.0,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
