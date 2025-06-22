import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/quiz/QuizScreen.dart';

class DuolingoApp extends StatelessWidget {
  const DuolingoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duolingo Clone',
      theme: AppTheme.lightTheme, // tuỳ bạn setup trong theme.dart
      home: QuizScreen(),
    );
  }
}
