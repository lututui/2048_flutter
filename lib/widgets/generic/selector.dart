import 'package:flutter/material.dart';

typedef SelectCallback = void Function(int);

/// A widget that shows one of its children at a time, between two buttons to
/// cycle between the shown child
class Selector extends StatefulWidget {
  /// Creates a new selector widget
  const Selector({
    @required this.children,
    this.onSelectChange,
    this.defaultOption = 0,
    Key key,
  })  : assert(children != null),
        super(key: key);

  /// The children to select from
  final List<Widget> children;

  /// Callback function called when the selected child changes
  final SelectCallback onSelectChange;

  /// The index of the default selected child
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
