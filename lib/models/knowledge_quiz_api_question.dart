import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'knowledge_quiz_question.dart';

class ApiService {
   // Theo dõi thời gian gửi yêu cầu cuối cùng
  static DateTime? _lastRequestTime;// lưu trữ thời gian gửi yêu cầu cuối cùng
  static const int _minRequestIntervalMs = 1000; //  Khoảng cách tối thiểu giữa các yêu cầu: 1 giây
  static const int _maxRetries = 3; // Số lần thử lại tối đa nếu gặp lỗi 429
  static const int _retryDelaySeconds = 5; //  Thời gian chờ trước khi thử lại sau lỗi 429
  Future<List<Question>> fetchQuestions({int amount = 1}) async {
    // Đảm bảo khoảng cách tối thiểu giữa các yêu cầu
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      final remainingMs = _minRequestIntervalMs - timeSinceLastRequest.inMilliseconds;
      if (remainingMs > 0) {
        await Future.delayed(Duration(milliseconds: remainingMs));
      }
    }

    final url = Uri.parse('https://opentdb.com/api.php?amount=50');
    _lastRequestTime = DateTime.now();

    for (int attempt = 1; attempt <= _maxRetries; attempt++) {
      try {
        final response = await http.get(url).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body); // Chuyển JSON thành Map
          if (data['response_code'] == 0) {
            return (data['results'] as List)
                .map((json) => Question.fromJson(json))
                .toList();
          } else {
            throw Exception('API returned error code: ${data['response_code']}');
          }
        } else if (response.statusCode == 429) {
          if (attempt == _maxRetries) {
            throw Exception('HTTP error: 429 - Too many requests, max retries reached.');
          }
           // Chờ trước khi thử lại
          await Future.delayed(Duration(seconds: _retryDelaySeconds));
          continue;
        } else {
          throw Exception('HTTP error: ${response.statusCode}');
        }
      } on TimeoutException {
        throw Exception('Request timed out. Please check your network connection.');
      } catch (e) {
        throw Exception('Error fetching questions: $e');
      }
    }
    throw Exception('Failed to fetch questions after $_maxRetries attempts.');
  }
}