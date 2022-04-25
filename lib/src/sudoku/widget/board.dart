import 'dart:math';

import 'package:flutter/material.dart' hide SelectIntent, SelectAction;
import 'package:flutter/services.dart';

import '../../selection shortcut/selection_shortcut.dart';
import '../../widgets/default_shortcuts_handler.dart';
import '../../widgets/neumorphism_button.dart';
import '../controller/sudoku.dart';

class SudokuBoard extends StatefulWidget {
  const SudokuBoard({
    required this.sudoku,
    this.selectedColor,
    this.itemBuilder,
    this.onTapIndex,
    this.numbersPadding,
    this.border,
    Key? key,
  }) : super(key: key);

  final SudokuPositionController sudoku;
  final IndexedWidgetBuilder? itemBuilder;
  final void Function(int index)? onTapIndex;
  final BoxBorder? border;
  final Color? selectedColor;
  final EdgeInsetsGeometry? numbersPadding;

  @override
  State<SudokuBoard> createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  late final nodes = [
    for (int i = 0; i < lengthSquared; i++) FocusNode(),
  ];

  int lastSelected = -1;
  int get length => widget.sudoku.length;
  int? _lengthSquared;
  int get lengthSquared {
    _lengthSquared ??= pow(length, 2).toInt();
    return _lengthSquared!;
  }

  void selectionListener() {
    if (widget.sudoku.selected > -1) {
      nodes[widget.sudoku.selected].requestFocus();
    } else if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    lastSelected = widget.sudoku.selected;
  }

  @override
  void initState() {
    widget.sudoku.selectedIndex.addListener(selectionListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.sudoku.selectedIndex.removeListener(selectionListener);
    for (final node in nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sudokuBorderEvery = pow(length, 1 / 2);
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          for (int i = 0; i < length; i++) ...[
            if ((i > 0) && ((i % sudokuBorderEvery) == 0)) const Divider(),
            Expanded(
              child: Row(
                children: [
                  for (int index = i * length;
                      (index - i * length) < length;
                      index++) ...[
                    if (((index - i * length) > 0) &&
                        (((index - i * length) % sudokuBorderEvery) == 0))
                      const VerticalDivider(),
                    Expanded(
                      child: Padding(
                        padding:
                            widget.numbersPadding ?? const EdgeInsets.all(8),
                        child: AnimatedBuilder(
                          animation: widget.sudoku,
                          builder: (context, child) {
                            return button(index);
                          },
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  static const Map<ShortcutActivator, Intent> _shortcuts = {
    CharacterActivator('0'): _SetValueIntent(0),
    CharacterActivator('1'): _SetValueIntent(1),
    CharacterActivator('2'): _SetValueIntent(2),
    CharacterActivator('3'): _SetValueIntent(3),
    CharacterActivator('4'): _SetValueIntent(4),
    CharacterActivator('5'): _SetValueIntent(5),
    CharacterActivator('6'): _SetValueIntent(6),
    CharacterActivator('7'): _SetValueIntent(7),
    CharacterActivator('8'): _SetValueIntent(8),
    CharacterActivator('9'): _SetValueIntent(9),
  };

  Widget button(int index) {
    return DefaultShortcuts(
      downFocus: () => downFocus(index),
      nextFocus: () => nextFocus(index),
      previousFocus: () => previousFocus(index),
      upFocus: () => upFocus(index),
      shortcuts: {}
        ..addAll(_shortcuts)
        ..addAll(SelectIntent.shortcuts),
      actions: {
        _SetValueIntent: _SetValueAction(index: index, sudoku: widget.sudoku),
        SelectIntent: SelectAction(widget.sudoku),
      },
      child: Focus(
        focusNode: nodes[index],
        onKey: (_, event) {
          if ((nodes[index].hasFocus) && (event is RawKeyDownEvent)) {
            return clearNumber(event, index);
          } else {
            return KeyEventResult.ignored;
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: widget.sudoku.selectedIndex,
          builder: (context, selected, child) {
            return NeumorphismButton(
              selectedColor: index == selected ? widget.selectedColor : null,
              border: index == selected ? widget.border : null,
              onTap: () {
                widget.sudoku.selected = index;
                if (lastSelected != -1) {
                  nodes[lastSelected].unfocus(
                    disposition: UnfocusDisposition.previouslyFocusedChild,
                  );
                }
                nodes[index].requestFocus();
                widget.onTapIndex?.call(index);
              },
              isSelected: index == selected,
              child: FittedBox(
                fit: BoxFit.contain,
                child: widget.itemBuilder?.call(context, index) ?? child!,
              ),
            );
          },
          child: Text('${widget.sudoku[index]}'),
        ),
      ),
    );
  }

  KeyEventResult movingFocus(RawKeyUpEvent event, int index) {
    if ((event.logicalKey == LogicalKeyboardKey.arrowLeft) ||
        (event.logicalKey == LogicalKeyboardKey.keyA)) {
      previousFocus(index);
      return KeyEventResult.handled;
    } else if ((event.logicalKey == LogicalKeyboardKey.arrowRight) ||
        (event.logicalKey == LogicalKeyboardKey.keyD)) {
      nextFocus(index);
      return KeyEventResult.handled;
    } else if ((event.logicalKey == LogicalKeyboardKey.arrowUp) ||
        (event.logicalKey == LogicalKeyboardKey.keyW)) {
      upFocus(index);
      return KeyEventResult.handled;
    } else if ((event.logicalKey == LogicalKeyboardKey.arrowDown) ||
        (event.logicalKey == LogicalKeyboardKey.keyS)) {
      downFocus(index);
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  KeyEventResult clearNumber(RawKeyEvent event, int index) {
    if ((event.logicalKey == LogicalKeyboardKey.backspace) ||
        (event.logicalKey == LogicalKeyboardKey.delete)) {
      widget.sudoku[index] = 0;
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  void previousFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLast = nodes.length - 1;
    if (nodes[index] != nodes.first) {
      widget.sudoku.selected = index - 1;
      nodes[index - 1].requestFocus();
      widget.onTapIndex?.call(index - 1);
    } else {
      widget.sudoku.selected = indexLast;
      nodes.last.requestFocus();
      widget.onTapIndex?.call(indexLast);
    }
  }

  void downFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLastRow = nodes.length - 10;
    if (index < indexLastRow) {
      widget.sudoku.selected = index + 9;
      nodes[index + 9].requestFocus();
      widget.onTapIndex?.call(index + 9);
    } else {
      widget.sudoku.selected = index % 9;
      nodes[index % 9].requestFocus();
      widget.onTapIndex?.call(index % 9);
    }
  }

  void upFocus(int index) {
    if (lastSelected != -1) {
      nodes[lastSelected].unfocus(
        disposition: UnfocusDisposition.previouslyFocusedChild,
      );
    }
    final indexLastRow = nodes.length - 9;
    const indexLastSquareFirstRow = 8;
    if (index > indexLastSquareFirstRow) {
      widget.sudoku.selected = index - 9;
      nodes[index - 9].requestFocus();
      widget.onTapIndex?.call(index - 9);
    } else {
      widget.sudoku.selected = indexLastRow + index;
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
      widget.sudoku.selected = index + 1;
      nodes[index + 1].requestFocus();
      widget.onTapIndex?.call(index + 1);
    } else {
      widget.sudoku.selected = 0;
      nodes.first.requestFocus();
      widget.onTapIndex?.call(0);
    }
  }
}

class _SetValueAction extends Action<_SetValueIntent> {
  _SetValueAction({
    required this.sudoku,
    required this.index,
  });

  final SudokuPositionController sudoku;
  final int index;

  @override
  Object? invoke(_SetValueIntent intent) {
    sudoku[index] = intent.value;
    return null;
  }
}

class _SetValueIntent extends Intent {
  const _SetValueIntent(this.value);

  final int value;
}
