import 'package:flutter/material.dart' hide SelectIntent, SelectAction;

import '../control/widget.dart';
import '../selection shortcut/selection_shortcut.dart';
import '../sudoku/sudoku.dart';
import '../widgets/link.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final sudoku = SudokuPositionController.blank;
  final _selectedControl = ValueNotifier<int>(-1);
  late final node = FocusNode()
    ..requestFocus()
    ..addListener(listener);

  int selectedSudoku = -1;

  int get selectedControl => _selectedControl.value;
  set selectedControl(int newValue) {
    if (newValue != selectedControl) {
      _selectedControl.value = newValue;
    } else {
      _selectedControl.value = -1;
    }
  }

  void listener() {
    debugPrint('node: ${node.hasFocus}');
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(node);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    node.removeListener(listener);
    node.dispose();
    _selectedControl.dispose();
    sudoku.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shortcuts(
      shortcuts: SelectIntent.shortcuts,
      child: Actions(
        actions: {SelectIntent: SelectAction(sudoku)},
        child: Focus(
          focusNode: node,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Sudoku'),
                actions: [
                  FittedBox(
                    child: Link(
                      text: 'Eraser icons',
                      link: 'https://www.flaticon.com/free-icons/eraser',
                      semanticsLabel: 'Eraser icons reference',
                      tooltip: 'Eraser icons created by pongsakornRed - '
                          'Flaticon',
                      style: theme.textTheme.bodyText2?.apply(
                        color: Colors.transparent,
                        decorationColor: theme.colorScheme.onPrimary,
                        shadows: [
                          Shadow(
                            blurRadius: 0,
                            color: theme.colorScheme.onPrimary,
                            offset: const Offset(0, -2),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: body,
            ),
          ),
        ),
      ),
    );
  }

  Widget get body {
    return OrientationBuilder(
      builder: (context, orientation) {
        final theme = Theme.of(context);
        final color = theme.colorScheme.secondary;
        return Flex(
          direction: orientation == Orientation.portrait
              ? Axis.vertical
              : Axis.horizontal,
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SudokuBoard(
                    sudoku: sudoku,
                    onTapIndex: (index) {
                      if (selectedControl.isNegative) {
                        selectedSudoku = index;
                      } else {
                        if (selectedControl < 9) {
                          sudoku[index] = selectedControl + 1;
                        } else {
                          sudoku[index] = 0;
                        }
                      }
                    },
                    numbersPadding: const EdgeInsets.all(2),
                    border: Border.all(color: color),
                    itemBuilder: (context, index) {
                      final value = sudoku[index];
                      if (value != 0) {
                        return Text('$value');
                      } else {
                        return const Text(' ');
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedControl,
                builder: (context, _, __) {
                  return Control(
                    direction: orientation == Orientation.landscape
                        ? Axis.horizontal
                        : Axis.vertical,
                    selectedIndex: selectedControl,
                    onTapIndex: (index) {
                      if (!selectedControl.isNegative) {
                        selectedControl = index;
                      } else {
                        if (selectedSudoku >= 0) {
                          if (index < 9) {
                            sudoku[selectedSudoku] = index + 1;
                          } else {
                            sudoku[selectedSudoku] = 0;
                          }
                        }
                      }
                    },
                    onLongPressIndex: (selected) {
                      selectedControl = selected;
                      if (!selected.isNegative) {
                        sudoku.clearSelection();
                      }
                    },
                    border: Border.all(color: color),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
