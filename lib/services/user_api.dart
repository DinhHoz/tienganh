import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  static const String baseUrl =
      'http://10.0.2.2/api_english_app'; // địa chỉ IP máy chủ

  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
    String name,
  ) async {
    final url = Uri.parse('http://10.0.2.2/api_english_app/register.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      // Decode UTF-8 để tránh lỗi Unicode
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded;
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }
}
