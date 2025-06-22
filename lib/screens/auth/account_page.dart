import 'package:flutter/material.dart';
import 'user_profile.dart'; // Đảm bảo UserProfilePage nhận userId

class HomePage extends StatelessWidget {
  final int userId;

  const HomePage({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(userId: userId),
              ),
            );
          },
          child: const Text("Xem hồ sơ người dùng"),
        ),
      ),
    );
  }
}
