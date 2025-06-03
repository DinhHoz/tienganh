import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/home/intro_screen.dart';
import 'screens/home/intro_screen_coban.dart';
import 'screens/home/intro_screen_luachon.dart';
import 'screens/home/intro_srceen_StudyPlan.dart';
import 'screens/home/intro_srceen_StudyPlan_1.dart';
import 'screens/home/intro_srceen_StudyPlan_2.dart';
import 'screens/home/screen_study.dart';
import 'screens/home/list_words_screen.dart';
import 'screens/home/login_screen.dart';
import 'screens/home/register_screen.dart';
import 'screens/home/account_page.dart';
import 'screens/home/dictionary_screen.dart';
import 'screens/home/QuizScreen.dart';

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
