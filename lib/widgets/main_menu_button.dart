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
      padding: const EdgeInsets.all(2.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Palette.OUTLINE_BUTTON_BACKGROUND_COLOR,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            buttonTheme: ButtonTheme.of(context).copyWith(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          child: OutlineButton(
            borderSide: BorderSide(
              width: 2.0,
              color: Palette.OUTLINE_BUTTON_BORDER_COLOR,
            ),
            onPressed: () => Navigator.of(context).pushNamed(this.routeName),
            child: Text(
              this.buttonText,
              style: TextStyle(
                color: Palette.OUTLINE_BUTTON_TEXT_COLOR,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
