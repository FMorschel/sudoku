import 'package:flutter/material.dart';

import '../controller/sudoku.dart';

class SudokuBoard extends StatelessWidget {
  const SudokuBoard({
    Key? key,
    required this.sudoku,
    this.onTapIndex,
  }) : super(key: key);

  final Sudoku sudoku;
  final void Function(int index)? onTapIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          for (int i = 0; i < sudoku.length; i++)
            Expanded(
              child: Row(
                children: [
                  for (int index = i * 9;
                      (index - i * 9) < sudoku.length;
                      index++)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTapIndex?.call(index),
                        child: Card(
                          child: Center(
                            child: AnimatedBuilder(
                              animation: sudoku,
                              builder: (context, child) {
                                return Text('${sudoku[index]}');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
