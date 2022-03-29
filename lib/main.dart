import 'package:flutter/material.dart';

import 'src/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF46BBD6),
      secondary: const Color(0xFF8A705A),
      secondaryContainer: const Color(0xFFDF9B5E),
      background: Colors.grey[300],
      onSurface: Colors.grey[300],
    );
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData.from(
        colorScheme: colorScheme,
        textTheme: theme.textTheme,
      ).copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[300],
        backgroundColor: Colors.grey[300],
        cardColor: Colors.grey[300],
        dividerTheme: DividerThemeData(
          color: Colors.grey[700],
          space: 5,
          thickness: 3,
          endIndent: 0,
          indent: 0,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}
