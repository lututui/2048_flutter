import 'package:flutter/material.dart';

class SwitchSettingWidget extends StatelessWidget {
  final void Function(bool) onChangedCallback;
  final String text;
  final bool value;

  const SwitchSettingWidget({
    Key key,
    @required this.text,
    @required this.value,
    @required this.onChangedCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.text),
          Switch(value: this.value, onChanged: this.onChangedCallback),
        ],
      ),
    );
  }
}
