import 'package:app_tieng_anh/screens/home/intro_screen.dart';
import 'package:app_tieng_anh/screens/home/login_screen.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'screens/home/home_page.dart';
import 'screens/home/knowledge_quiz_screen.dart';
import 'screens/home/QuizScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Quiz App',
      theme: ThemeData.dark(),
      home: IntroScreen(),
    );
  }
}

void checkFirebaseConnected() async {
  bool isConnected = await Firebase.apps.isNotEmpty;
  print('Firebase connected: $isConnected');
}
