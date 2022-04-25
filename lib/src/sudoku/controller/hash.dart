part of 'sudoku.dart';

class Hash<E> implements BaseHash<E> {
  Hash(
    final E first,
    final E second,
    final E third,
    final E fourth,
    final E fifth,
    final E sixth,
    final E seventh,
    final E eighth,
    final E nineth,
  ) : _list = [
          [first, second, third],
          [fourth, fifth, sixth],
          [seventh, eighth, nineth],
        ];

  factory Hash.byRows({
    required List<E> first,
    required List<E> second,
    required List<E> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return Hash._([first, second, third]);
  }

  factory Hash.byColumns({
    required List<E> first,
    required List<E> second,
    required List<E> third,
  }) {
    assert(first.length == 3);
    assert(second.length == 3);
    assert(third.length == 3);
    return Hash._([
      for (int i = 0; i < 3; i++) [first[i], second[i], third[i]]
    ]);
  }

  const Hash._(final List<List<E>> list) : _list = list;

  static Hash<int> get zeros => Hash<int>.byColumns(
        first: _zeros,
        second: _zeros,
        third: _zeros,
      );

  static const _zeros = [0, 0, 0];

  final List<List<E>> _list;

  @override
  List<E> column(int index) {
    assert((index >= 0) && (index < length));
    return [
      _list[0][index],
      _list[1][index],
      _list[2][index],
    ];
  }

  @override
  List<E> row(int index) {
    assert((index >= 0) && (index < length));
    return _list[index];
  }

  @override
  List<E> get values =>
      [for (int index = 0; index < length; index++) ...row(index)];

  @override
  E operator [](int index) {
    assert((index >= 0) && (index < pow(length, 2)));
    return _list[index ~/ length][index % length];
  }

  @override
  void operator []=(int index, E value) {
    assert((index >= 0) && (index < pow(length, 2)));
    _list[index ~/ length][index % length] = value;
  }

  @override
  List<List<E>> get columns => [
        for (int index = 0; index < length; index++) column(index),
      ];

  @override
  List<List<E>> get rows => [
        for (int index = 0; index < length; index++) row(index),
      ];

  @override
  int get length => 3;
}
