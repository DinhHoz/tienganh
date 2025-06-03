import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'knowledge_quiz_question.dart';

class ApiService {
  // Keep track of the last request time
  static DateTime? _lastRequestTime;
  static const int _minRequestIntervalMs = 1000; // 1 second between requests
  static const int _maxRetries = 3; // Maximum retries for 429 errors
  static const int _retryDelaySeconds = 5; // Delay before retrying after 429

  Future<List<Question>> fetchQuestions({int amount = 1}) async {
    // Ensure minimum interval between requests
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
          final data = jsonDecode(response.body);
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
          // Wait before retrying
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