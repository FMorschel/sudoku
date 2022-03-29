import 'dart:math';

import 'package:flutter/material.dart' show ChangeNotifier;

part 'hash.dart';
part 'base_hash.dart';

class Sudoku extends ChangeNotifier implements BaseHash<int> {
  static final blank = Sudoku.byColumns(
    first: [Hash.zeros(), Hash.zeros(), Hash.zeros()],
    second: [Hash.zeros(), Hash.zeros(), Hash.zeros()],
    third: [Hash.zeros(), Hash.zeros(), Hash.zeros()],
  );

  Sudoku(
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

  final Hash<Hash<int>> _board;

  factory Sudoku.byRows({
    required List<Hash<int>> first,
    required List<Hash<int>> second,
    required List<Hash<int>> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return Sudoku(
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

  factory Sudoku.byColumns({
    required List<Hash<int>> first,
    required List<Hash<int>> second,
    required List<Hash<int>> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return Sudoku(
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

  List<int> hash(int index) {
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
    final row = index ~/ length % pow(length, 1 / 2).toInt();
    final column = index % length % pow(length, 1 / 2).toInt();
    return _board[_hashIndex(index)][row * pow(length, 1 / 2).toInt() + column];
  }

  @override
  void operator []=(int index, int value) {
    assert((index >= 0) && (index < pow(length, 2)));
    final row = index ~/ length % pow(length, 1 / 2).toInt();
    final column = index % length % pow(length, 1 / 2).toInt();
    final innerHashIndex = row * pow(length, 1 / 2).toInt() + column;
    _board[_hashIndex(index)][innerHashIndex] = value;
    notifyListeners();
  }

  int _hashIndex(int index) {
    final hashRow = index ~/ length ~/ pow(length, 1 / 2);
    final hashColumn = index % length ~/ pow(length, 1 / 2);
    return hashRow * pow(length, 1 / 2).toInt() + hashColumn;
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
  int get length => 9;
}
