import 'package:flutter/material.dart';

typedef SelectCallback = void Function(int);

class Selector extends StatefulWidget {
  final List<Widget> children;
  final SelectCallback onSelectChange;
  final int defaultOption;

  const Selector({
    Key key,
    @required this.children,
    this.onSelectChange,
    this.defaultOption = 0,
  })  : assert(children != null),
        super(key: key);

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  int selected;

  @override
  void initState() {
    super.initState();

    this.selected = this.widget.defaultOption;
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
              if (this.selected == 0) {
                this.selected = this.widget.children.length - 1;
              } else {
                this.selected--;
              }

              this.widget.onSelectChange(this.selected);
            });
          },
        ),
        this.widget.children[this.selected],
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: () {
            setState(() {
              if (this.selected == this.widget.children.length - 1) {
                this.selected = 0;
              } else {
                this.selected++;
              }

              this.widget.onSelectChange(this.selected);
            });
          },
        ),
      ],
    );
  }
}
