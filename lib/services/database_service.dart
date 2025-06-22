import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_tieng_anh/models/user.dart';

class DatabaseService {
  static Future<Users?> getUserById(int id) async {
    try {
      final url = Uri.parse(
        'http://10.0.2.2/api_english_app/get_user.php?id=$id',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["error"] != null) {
          print("Error từ server: ${data["error"]}");
          return null;
        }

        List<String> learnedWords = [];
        if (data['learned_words'] != null) {
          learnedWords = List<String>.from(data['learned_words']);
        }

        return Users(
          id: int.parse(data['id'].toString()),
          name: data['name'],
          username: data['username'],
          email: data['email'],
          password: data['password'],
          avatarUrl: data['avatar_url'] ?? '',
          streakDays: int.parse(data['streak_days'].toString()),
          startDate: DateTime.parse(data['start_date']),
          wordsLearned: int.parse(data['words_learned'].toString()),
          learnedWords: learnedWords,
        );
      } else {
        print(" Lỗi khi gọi API: ${response.statusCode}");
      }
    } catch (e) {
      print(" Exception khi gọi API: $e");
    }
    return null;
  }

  static Future<bool> updatePassword(int id, String newPassword) async {
    try {
      final url = Uri.parse(
        'http://10.0.2.2/api_english_app/get_user.php?id=$id',
      );

      // Gửi POST request với body chứa new_password
      final response = await http.post(
        url,
        body: {'id': id.toString(), 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] != null) {
          print("Update password success: ${data['success']}");
          return true;
        } else if (data['error'] != null) {
          print("Update password error: ${data['error']}");
          return false;
        }
      } else {
        print("Lỗi khi gọi API update mật khẩu: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception khi update mật khẩu: $e");
    }
    return false;
  }
}
