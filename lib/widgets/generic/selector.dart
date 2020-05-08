import 'package:flutter/material.dart';

typedef SelectCallback = void Function(int);

class Selector extends StatefulWidget {
  const Selector({
    @required this.children,
    this.onSelectChange,
    this.defaultOption = 0,
    Key key,
  })  : assert(children != null),
        super(key: key);

  final List<Widget> children;
  final SelectCallback onSelectChange;
  final int defaultOption;

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  int selected;

  @override
  void initState() {
    super.initState();

    selected = widget.defaultOption;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            setState(() {
              if (selected == 0) {
                selected = widget.children.length - 1;
              } else {
                selected--;
              }

              widget.onSelectChange(selected);
            });
          },
        ),
        widget.children[selected],
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            setState(() {
              if (selected == widget.children.length - 1) {
                selected = 0;
              } else {
                selected++;
              }

              widget.onSelectChange(selected);
            });
          },
        ),
      ],
    );
  }
}
