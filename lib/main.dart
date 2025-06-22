import 'package:app_tieng_anh/screens/home/intro_screen.dart';
import 'package:app_tieng_anh/screens/home/intro_screen_1.dart';
import 'package:app_tieng_anh/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'screens/home/home_page.dart';
import 'screens/quiz/knowledge_quiz_screen.dart';
import 'screens/quiz/QuizScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/services/notification_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    // Khởi tạo NotificationService
  final notificationService = NotificationService();
  await notificationService.initNotification();
  try {
    // Khởi tạo Firebase
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    checkFirebaseConnected();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp(notificationService: notificationService));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required NotificationService notificationService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Quiz App',
      theme: ThemeData.dark(),
      home: const IntroScreen1(), 
    );
  }
}

void checkFirebaseConnected() {
  bool isConnected = Firebase.apps.isNotEmpty;
  print('Firebase connected: $isConnected');
}
