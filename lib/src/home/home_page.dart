import 'package:flutter/material.dart';
import '../sudoku/sudoku.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final sudoku = Sudoku.blank;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
      ),
      body: Center(
        child: SudokuBoard(
          sudoku: sudoku,
          onTapIndex: (index) => sudoku[index]++,
        ),
      ),
    );
  }
}
