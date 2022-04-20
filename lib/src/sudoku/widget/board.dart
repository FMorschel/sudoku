import 'dart:math';

import 'package:flutter/material.dart';

import '../../widgets/neumorphism_button.dart';
import '../controller/sudoku.dart';

class SudokuBoard extends StatefulWidget {
  const SudokuBoard({
    required this.sudoku,
    this.selectedColor,
    this.itemBuilder,
    this.onTapIndex,
    this.border,
    Key? key,
  }) : super(key: key);

  final SudokuPositionController sudoku;
  final IndexedWidgetBuilder? itemBuilder;
  final void Function(int index)? onTapIndex;
  final BoxBorder? border;
  final Color? selectedColor;

  @override
  State<SudokuBoard> createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final length = widget.sudoku.length;
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
                  for (int index = i * 9;
                      (index - i * 9) < length;
                      index++) ...[
                    if (((index - i * 9) > 0) &&
                        (((index - i * 9) % sudokuBorderEvery) == 0))
                      const VerticalDivider(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AnimatedBuilder(
                          animation: widget.sudoku,
                          builder: (context, child) {
                            return NeumorphismButton(
                              selectedColor: index == selectedIndex
                                  ? widget.selectedColor
                                  : null,
                              border:
                                  index == selectedIndex ? widget.border : null,
                              onTap: () {
                                selectedIndex = index;
                                widget.onTapIndex?.call(index);
                              },
                              isSelected: index == selectedIndex,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child:
                                    widget.itemBuilder?.call(context, index) ??
                                        Text('${widget.sudoku[index]}'),
                              ),
                            );
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
}
