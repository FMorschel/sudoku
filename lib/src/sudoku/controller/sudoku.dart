import 'dart:math';

import 'package:flutter/foundation.dart';

part 'hash.dart';
part 'base_hash.dart';

class SudokuPositionController extends ChangeNotifier implements BaseHash<int> {
  SudokuPositionController(
    Hash<int> first,
    Hash<int> second,
    Hash<int> third,
    Hash<int> fourth,
    Hash<int> fifth,
    Hash<int> sixth,
    Hash<int> seventh,
    Hash<int> eighth,
    Hash<int> nineth,
  ) : _board = Hash<Hash<int>>(
          first,
          second,
          third,
          fourth,
          fifth,
          sixth,
          seventh,
          eighth,
          nineth,
        );

  factory SudokuPositionController.byRows({
    required List<Hash<int>> first,
    required List<Hash<int>> second,
    required List<Hash<int>> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return SudokuPositionController(
      first[0],
      first[1],
      first[2],
      second[0],
      second[1],
      second[2],
      third[0],
      third[1],
      third[2],
    );
  }

  factory SudokuPositionController.byColumns({
    required List<Hash<int>> first,
    required List<Hash<int>> second,
    required List<Hash<int>> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return SudokuPositionController(
      first[0],
      second[0],
      third[0],
      first[1],
      second[1],
      third[1],
      first[2],
      second[2],
      third[2],
    );
  }

  static SudokuPositionController get blank =>
      SudokuPositionController.byColumns(
        first: [Hash.zeros, Hash.zeros, Hash.zeros],
        second: [Hash.zeros, Hash.zeros, Hash.zeros],
        third: [Hash.zeros, Hash.zeros, Hash.zeros],
      );

  final Hash<Hash<int>> _board;
  final selectedIndex = ValueNotifier<int>(-1);

  void clearSelection() => selected = -1;

  int get selectedRow => selected.isNegative ? -1 : selected ~/ length;
  set selectedRow(int index) {
    assert((index >= -1) && (index <= 8));
    selected = (index * 9) + ((selectedColumn >= 0) ? selectedColumn : 0);
  }

  int get selectedColumn => selected.isNegative ? -1 : selected % length;
  set selectedColumn(int index) {
    assert((index >= -1) && (index <= 8));
    selected = index + (((selectedRow >= 0) ? selectedRow : 0) * 9);
  }

  int get selectedSquare => _boxIndex(selected);
  set selectedSquare(int index) {
    assert((index >= -1) && (index < length));
    final root = pow(length, 1 / 2).toInt();
    selected = (index % root * root) + (index ~/ root * (length * root));
  }

  int get selected => selectedIndex.value;
  set selected(int newState) {
    assert((newState >= -1) && (newState <= 80));
    selectedIndex.value = newState;
  }

  @override
  List<int> column(int index) {
    assert((index >= 0) && (index < length));
    final List<int> list = [];
    for (final hash in _board.column(index ~/ pow(length, 1 / 2))) {
      list.addAll(hash.column(index % (pow(length, 1 / 2).toInt())));
    }
    return list;
  }

  @override
  List<int> row(int index) {
    assert((index >= 0) && (index < length));
    final List<int> list = [];
    for (final hash in _board.row(index ~/ pow(length, 1 / 2))) {
      list.addAll(hash.row(index % (pow(length, 1 / 2).toInt())));
    }
    return list;
  }

  List<int> box(int index) {
    assert((index >= 0) && (index < length));
    return _board[index].values;
  }

  @override
  List<int> get values => [
        for (int index = 0; index < length; index++) ...row(index),
      ];

  @override
  int operator [](int index) {
    assert((index >= 0) && (index < pow(length, 2)));
    return _board[_boxIndex(index)][_innerHashIndex(index)];
  }

  @override
  void operator []=(int index, int value) {
    assert((index >= 0) && (index < pow(length, 2)));
    assert((value >= 0) && (value <= 9));
    _board[_boxIndex(index)][_innerHashIndex(index)] = value;
    notifyListeners();
    if (noEmptyUnits) debugPrint('Done: ${verify()}');
  }

  bool verify() {
    if (noEmptyUnits) {
      for (int index = 0; index < pow(length, 2); index++) {
        final repeatedPeersInUnits = repeatedPeersFromAllUnitsAt(index);
        for (final repeatedPeers in repeatedPeersInUnits.values) {
          if (repeatedPeers > 0) {
            debugPrint('sudoku[$index]:$repeatedPeersInUnits');
            return false;
          }
        }
      }
      return true;
    } else {
      return false;
    }
  }

  List<int> _rowOf(int index) => row(index ~/ length);
  List<int> _columnOf(int index) => column(index % length);
  List<int> _boxOf(int index) => box(_boxIndex(index));

  Map<String, int> repeatedPeersFromAllUnitsAt(
    int index, [
    void Function(int)? onRowNumbers,
    void Function(int)? onColumnNumbers,
    void Function(int)? onHashNumbers,
  ]) {
    debugPrint(
      'Index: $index\nValue:${this[index]}\nRow:${_rowOf(index)}'
      '\nColumn:${_columnOf(index)}\nBox:${_boxOf(index)}',
    );
    final values = <String, int>{
      'Row': _verifyRepeatedValue(this[index], _rowOf(index)).length,
      'Column': _verifyRepeatedValue(this[index], _columnOf(index)).length,
      'Box': _verifyRepeatedValue(this[index], _boxOf(index)).length,
    };
    if (values['Row']! > 0) onRowNumbers?.call(values['Row']!);
    if (values['Column']! > 0) onColumnNumbers?.call(values['Column']!);
    if (values['Box']! > 0) onHashNumbers?.call(values['Box']!);
    return values;
  }

  bool get noEmptyUnits => values.every((element) => element != 0);

  List<int> _verifyRepeatedValue(int value, List<int> values) {
    return [...values.where((element) => element == value)].sublist(1);
  }

  int _boxIndex(int index) {
    if (!index.isNegative && index < 81) {
      final hashRow = index ~/ length ~/ pow(length, 1 / 2);
      final hashColumn = index % length ~/ pow(length, 1 / 2);
      return hashRow * pow(length, 1 / 2).toInt() + hashColumn;
    } else {
      return -1;
    }
  }

  int _innerHashIndex(int index) {
    final row = index ~/ length % pow(length, 1 / 2).toInt();
    final column = index % length % pow(length, 1 / 2).toInt();
    return row * pow(length, 1 / 2).toInt() + column;
  }

  @override
  List<List<int>> get columns => [
        for (int index = 0; index < length; index++) column(index),
      ];

  @override
  List<List<int>> get rows => [
        for (int index = 0; index < length; index++) row(index),
      ];

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  int get length => 9;
}
