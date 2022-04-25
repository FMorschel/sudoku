import 'package:flutter/material.dart';

import '../widgets/default_shortcuts_handler.dart';
import '../widgets/neumorphism_button.dart';

typedef IndexedCallback = void Function(int index);

class Control extends StatefulWidget {
  const Control({
    required this.direction,
    this.border,
    this.onTapIndex,
    this.onLongPressIndex,
    this.selectedIndex = -1,
    Key? key,
  }) : super(key: key);

  final BoxBorder? border;
  final IndexedCallback? onTapIndex;
  final IndexedCallback? onLongPressIndex;
  final int selectedIndex;
  final Axis direction;

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  int lastSelected = -1;
  late final nodes = [
    for (int i = 0; i < 10; i++) FocusNode(),
  ];

  @override
  void dispose() {
    for (final node in nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lastSelected = widget.selectedIndex;
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimension = widget.direction == Axis.vertical
            ? constraints.maxHeight / 2.5
            : constraints.maxWidth / 2.5;
        return Center(
          child: SizedBox(
            width: width * dimension,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                for (int index = 0; index < 10; index++)
                  controlButton(
                    index,
                    dimension,
                    child: index == 9
                        ? Image.asset('assets/images/eraser.png')
                        : null,
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget controlButton(
    int index,
    double dimension, {
    Widget? child,
  }) {
    return SizedBox.square(
      dimension: dimension,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: DefaultShortcuts(
          downFocus: () => downFocus(index),
          nextFocus: () => nextFocus(index),
          previousFocus: () => previousFocus(index),
          upFocus: () => upFocus(index),
          child: Focus(
            focusNode: nodes[index],
            child: NeumorphismButton(
              border: isSelected(index) ? widget.border : null,
              isSelected: isSelected(index),
              onTap: widget.onTapIndex != null
                  ? () {
                      if (lastSelected != -1) {
                        nodes[lastSelected].unfocus(
                          disposition:
                              UnfocusDisposition.previouslyFocusedChild,
                        );
                      }
                      nodes[index].requestFocus();
                      widget.onTapIndex!(index);
                    }
                  : null,
              onLongPress: () {
                if (lastSelected != -1) {
                  nodes[lastSelected].unfocus(
                    disposition: UnfocusDisposition.previouslyFocusedChild,
                  );
                }
                nodes[index].requestFocus();
                widget.onLongPressIndex?.call(index);
              },
              child: FittedBox(
                fit: BoxFit.contain,
                child: child ?? Text('${index + 1}'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isSelected(index) => widget.selectedIndex == index;

  void previousFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLast = nodes.length - 1;
    if (nodes[index] != nodes.first) {
      nodes[index - 1].requestFocus();
      widget.onTapIndex?.call(index - 1);
    } else {
      nodes.last.requestFocus();
      widget.onTapIndex?.call(indexLast);
    }
  }

  int get width => (widget.direction == Axis.vertical) ? 5 : 2;

  void downFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLastRow = nodes.length - width - 1;
    if (index < indexLastRow) {
      nodes[index + width].requestFocus();
      widget.onTapIndex?.call(index + width);
    } else {
      nodes[index % width].requestFocus();
      widget.onTapIndex?.call(index % width);
    }
  }

  void upFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLastRow = nodes.length - width;
    final indexLastSquareFirstRow = width - 1;
    if (index > indexLastSquareFirstRow) {
      nodes[index - width].requestFocus();
      widget.onTapIndex?.call(index - width);
    } else {
      nodes[indexLastRow + index].requestFocus();
      widget.onTapIndex?.call(indexLastRow + index);
    }
  }

  void nextFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    if (nodes[index] != nodes.last) {
      widget.onLongPressIndex?.call(index + 1);
      nodes[index + 1].requestFocus();
    } else {
      widget.onLongPressIndex?.call(0);
      nodes.first.requestFocus();
    }
  }
}
