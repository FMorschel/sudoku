import 'package:flutter/material.dart';

import '../sudoku/sudoku.dart';
import '../widgets/link.dart';
import '../widgets/neumorphism_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;
    final sudoku = SudokuPositionController.blank;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          Center(
            child: Link(
              text: 'Eraser icons created by pongsakornRed - Flaticon',
              link: 'https://www.flaticon.com/free-icons/eraser',
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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Flex(
            direction: orientation == Orientation.portrait
                ? Axis.vertical
                : Axis.horizontal,
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SudokuBoard(
                      sudoku: sudoku,
                      onTapIndex: (index) => sudoku[index]++,
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
                child: Control(
                  direction: orientation == Orientation.landscape
                      ? Axis.vertical
                      : Axis.horizontal,
                  border: Border.all(color: color),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Control extends StatefulWidget {
  const Control({
    Key? key,
    required this.direction,
    this.border,
  }) : super(key: key);

  final BoxBorder? border;
  final Axis direction;

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          direction: widget.direction,
          children: [
            for (int i = 0; i < 9; i++)
              SizedBox.square(
                dimension: widget.direction == Axis.vertical
                    ? constraints.maxHeight / 5
                    : constraints.maxWidth / 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: NeumorphismButton(
                    border: widget.border,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text('${i + 1}'),
                    ),
                  ),
                ),
              ),
            SizedBox.square(
              dimension: widget.direction == Axis.vertical
                  ? constraints.maxHeight / 5
                  : constraints.maxWidth / 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NeumorphismButton(
                  border: widget.border,
                  child: FittedBox(fit: BoxFit.contain, child: Image.asset('')),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
