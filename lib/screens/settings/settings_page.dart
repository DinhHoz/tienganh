import 'package:app_tieng_anh/models/user.dart';
import 'package:app_tieng_anh/screens/home/CoursesPage.dart';
import 'package:app_tieng_anh/screens/auth/edit_profile.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Users user;

  const SettingsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng trang
            },
            child: const Text(
              "HOÀN TẤT",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Tài khoản",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),

                // Cài đặt riêng
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Cài đặt riêng",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () {},
                  ),
                ),

                // Hồ sơ
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Hồ sơ",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(user: user),
                        ),
                      );
                    },
                  ),
                ),

                // Thông báo
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Thông báo",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () {},
                  ),
                ),

                // Khóa học
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: const Text(
                      "Khoá học",
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CoursesPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Đăng xuất
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Center(
                child: Text(
                  "Đăng xuất",
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                // TODO: Xử lý đăng xuất
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
