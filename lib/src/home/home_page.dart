import 'package:flutter/material.dart';
import '../sudoku/sudoku.dart';
import '../widgets/sizing_box.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.secondaryContainer;
    final sudoku = SudokuPositionController.blank;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
      ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Flex(
              direction: orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              children: [
                Expanded(
                  flex: 4,
                  child: SizingBox(
                    heightFactor: 0.85,
                    min: const Size.square(550),
                    child: SudokuBoard(
                      sudoku: sudoku,
                      onTapIndex: (index) => sudoku[index]++,
                      selectedColor: primary,
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
