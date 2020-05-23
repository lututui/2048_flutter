import 'package:flutter/material.dart';

/// A widget that shows one of its children at a time, between two arrow buttons
/// to cycle through the list of selectable children
class Selector extends StatefulWidget {
  /// Creates a new selector widget from an explicit [List] of children
  ///
  /// This constructor is not recommended for long lists as constructing
  /// [children] requires doing work for every child, not only the one currently
  /// selected.
  ///
  /// The [size] argument is forced to be the length of the provided list, and
  /// [builder] is null.
  const Selector({
    @required this.children,
    this.onChange,
    this.defaultOption = 0,
    this.wrapAround = true,
    Key key,
  })  : builder = null,
        assert(wrapAround != null),
        assert(children != null),
        size = children.length,
        super(key: key);

  /// Creates a new selector widget that builds its children on demand
  ///
  /// The implicit list of children must be finite, therefore a non-null,
  /// greater than zero, [size] argument must be provided.
  ///
  /// For a potentially infinite or with unknown amount of selectable children,
  /// see [Selector.unbounded]
  const Selector.builder({
    @required this.builder,
    @required this.size,
    this.onChange,
    this.defaultOption = 0,
    this.wrapAround = true,
    Key key,
  })  : children = null,
        assert(wrapAround != null),
        assert(size != null),
        assert(builder != null),
        super(key: key);

  /// Creates a new selector widget that builds its children on demand
  ///
  /// The implicit list of children is unbounded and, therefore, cannot wrap
  /// around (since there is no right edge).
  ///
  /// When first child is selected (index 0), the left arrow becomes disabled.
  const Selector.unbounded({
    @required this.builder,
    this.onChange,
    this.defaultOption = 0,
    Key key,
  })  : children = null,
        size = null,
        wrapAround = false,
        assert(builder != null),
        super(key: key);

  /// How many widgets are there to be selected.
  final int size;

  /// Whether the selector should wrap around.
  ///
  /// If true, when the first widget is selected and the left arrow is pressed,
  /// the new selected widget will be the last one. Likewise, when the last
  /// widget is selected and the right arrow is pressed, the new selected widget
  /// will be the first one.
  ///
  /// Requires a finite [size]. Selectors created with [Selector.unbounded]
  /// cannot wrap around. In this case, the left and right arrows are disabled
  /// when reaching either border
  final bool wrapAround;

  /// Called to build a child for this selector
  ///
  /// Will be called only if [children] is null.
  final IndexedWidgetBuilder builder;

  /// The children to select from
  ///
  /// Can be used instead of [builder]
  final List<Widget> children;

  /// Callback function called when the selected child changes
  ///
  /// Passes the index of the selected child as an argument
  final void Function(int) onChange;

  /// The index of the default selected child
  ///
  /// If changed, the selector will reset to the new default option
  final int defaultOption;

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  int _selected;

  @override
  void initState() {
    super.initState();

    _selected = widget.defaultOption;
  }

  @override
  void didUpdateWidget(Selector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.defaultOption != widget.defaultOption) {
      _selected = widget.defaultOption;
    }
  }

  bool get leftArrowEnabled => widget.wrapAround || _selected != 0;

  Widget buildLeftArrow(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.keyboard_arrow_left),
      onPressed: leftArrowEnabled
          ? () {
              setState(() {
                if (_selected == 0) {
                  assert(widget.wrapAround);
                  _selected = widget.size - 1;
                } else {
                  _selected--;
                }

                widget.onChange?.call(_selected);
              });
            }
          : null,
    );
  }

  bool get rightArrowEnabled =>
      widget.size == null || widget.wrapAround || _selected != widget.size - 1;

  Widget buildRightArrow(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.keyboard_arrow_right),
      onPressed: rightArrowEnabled
          ? () {
              setState(() {
                if (widget.size == null || _selected != widget.size - 1) {
                  _selected++;
                } else {
                  assert(widget.wrapAround);
                  _selected = 0;
                }

                widget.onChange(_selected);
              });
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildLeftArrow(context),
        if (widget.children != null)
          widget.children[_selected]
        else
          widget.builder(context, _selected),
        buildRightArrow(context),
      ],
    );
  }
}
