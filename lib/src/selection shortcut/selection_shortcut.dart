import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../sudoku/sudoku.dart';

enum Selection {
  square,
  column,
  row,
}

class SelectAction extends Action<SelectIntent> {
  SelectAction(this.board);

  final SudokuPositionController board;

  @override
  Object? invoke(SelectIntent intent) {
    debugPrint(intent.toString());
    switch (intent.selection) {
      case Selection.square:
        board.selectedSquare = intent.index - 1;
        break;
      case Selection.column:
        board.selectedColumn = intent.index - 1;
        break;
      case Selection.row:
        board.selectedRow = intent.index - 1;
        break;
    }
    return null;
  }
}

class SelectIntent extends Intent {
  const SelectIntent(
    this.index,
    this.selection,
  );

  final int index;
  final Selection selection;

  @override
  String toString({DiagnosticLevel? minLevel}) {
    return 'SelectIntent(\n  '
        'index: $index,\n  '
        'selection: $selection,\n  '
        ')';
  }

  static const Map<ShortcutActivator, Intent> shortcuts = {
    SingleActivator(LogicalKeyboardKey.numpad1, control: true):
        SelectIntent(1, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad1, alt: true):
        SelectIntent(1, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad1, shift: true):
        SelectIntent(1, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad2, control: true):
        SelectIntent(2, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad2, alt: true):
        SelectIntent(2, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad2, shift: true):
        SelectIntent(2, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad3, control: true):
        SelectIntent(3, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad3, alt: true):
        SelectIntent(3, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad3, shift: true):
        SelectIntent(3, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad4, control: true):
        SelectIntent(4, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad4, alt: true):
        SelectIntent(4, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad4, shift: true):
        SelectIntent(4, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad5, control: true):
        SelectIntent(5, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad5, alt: true):
        SelectIntent(5, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad5, shift: true):
        SelectIntent(5, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad6, control: true):
        SelectIntent(6, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad6, alt: true):
        SelectIntent(6, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad6, shift: true):
        SelectIntent(6, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad7, control: true):
        SelectIntent(7, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad7, alt: true):
        SelectIntent(7, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad7, shift: true):
        SelectIntent(7, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad8, control: true):
        SelectIntent(8, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad8, alt: true):
        SelectIntent(8, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad8, shift: true):
        SelectIntent(8, Selection.square),

    SingleActivator(LogicalKeyboardKey.numpad9, control: true):
        SelectIntent(9, Selection.column),
    SingleActivator(LogicalKeyboardKey.numpad9, alt: true):
        SelectIntent(9, Selection.row),
    SingleActivator(LogicalKeyboardKey.numpad9, shift: true):
        SelectIntent(9, Selection.square),

  };
}
