import 'dart:convert';
import 'package:http/http.dart' as http;

class WordApi {
  static const String baseUrl = 'http://10.0.2.2:80/api_english_app';

  /// Lấy danh sách word_id mà user đã học
  static Future<List<int>> getLearnedWords(int userId) async {
    final url = Uri.parse('$baseUrl/get_learned_words.php?user_id=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data['status'] == 'success') {
          List<dynamic> wordIds = data['word_ids'];
          return wordIds.map((id) => int.parse(id.toString())).toList();
        } else {
          throw Exception(data['message'] ?? 'Không thể lấy dữ liệu');
        }
      } else {
        throw Exception('Lỗi máy chủ: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      return [];
    }
  }

  static Future<bool> markAllLearnedWords(
    int userId,
    List<int> wordIndices,
  ) async {
    final url = Uri.parse('$baseUrl/mark_all_learned_words.php');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'word_indices': wordIndices}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data['status'] == 'success') {
          return true;
        } else {
          print('Lỗi từ server: ${data['message']}');
          return false;
        }
      } else {
        print('Lỗi kết nối server: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      return false;
    }
  }
}
