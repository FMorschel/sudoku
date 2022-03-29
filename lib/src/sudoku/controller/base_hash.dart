part of 'sudoku.dart';

abstract class BaseHash<E> {
  int get length;
  List<List<E>> get rows;
  List<List<E>> get columns;
  List<E> row(int index);
  List<E> column(int index);
  List<E> get values;
  E operator [](int index);
  void operator []=(int index, E value);
}
