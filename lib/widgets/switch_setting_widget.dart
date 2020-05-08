import 'package:flutter/material.dart';

class SwitchSettingWidget extends StatelessWidget {
  const SwitchSettingWidget({
    @required this.text,
    @required this.value,
    @required this.onChangedCallback,
    Key key,
  }) : super(key: key);

  final void Function(bool) onChangedCallback;
  final String text;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text),
          Switch(value: value, onChanged: onChangedCallback),
        ],
      ),
    );
  }
}
