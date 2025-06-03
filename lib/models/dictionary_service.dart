import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

class LookupResult {
  final Map<String, dynamic> rawData;
  final String audioUrl;

  LookupResult({required this.rawData, required this.audioUrl});

  /// Lấy phiên âm dạng text nếu có
  String get phonetic {
    if (rawData['phonetics'] != null && rawData['phonetics'] is List) {
      for (var phon in rawData['phonetics']) {
        if (phon['text'] != null && phon['text'].toString().isNotEmpty) {
          return phon['text'];
        }
      }
    }
    return '';
  }

  /// Lấy danh sách meanings
  List get meanings {
    if (rawData['meanings'] != null && rawData['meanings'] is List) {
      return rawData['meanings'];
    }
    return [];
  }
}

class DictionaryService {
  static const String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  
  static const String lingvaInstance = 'https://lingva.ml';

  /// Tra từ tiếng Anh, trả về LookupResult chứa dữ liệu và audio URL
  static Future<LookupResult?> lookupEnglishWord(String word) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$word'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final Map<String, dynamic> firstEntry = data[0];

          // Lấy audio URL từ phonetics
          String audioUrl = '';
          if (firstEntry['phonetics'] != null && firstEntry['phonetics'] is List) {
            for (var phon in firstEntry['phonetics']) {
              if (phon['audio'] != null && phon['audio'].toString().isNotEmpty) {
                audioUrl = phon['audio'];
                break;
              }
            }
          }
          return LookupResult(rawData: firstEntry, audioUrl: audioUrl);
        } else {
          return null;
        }
      } else {
        print("Lỗi API tra từ: ${response.statusCode}");
        return null;
      }
    } on SocketException {
      print("Không có kết nối mạng.");
      return null;
    } on TimeoutException {
      print("Quá thời gian khi tra từ.");
      return null;
    } catch (e) {
      print("Lỗi không xác định khi tra từ: $e");
      return null;
    }
  }

  /// Dịch văn bản bằng Lingva Translate (GET request)
  static Future<String?> translate(String text, String fromLang, String toLang) async {
    try {
      final encodedText = Uri.encodeComponent(text);
      final url = '$lingvaInstance/api/v1/$fromLang/$toLang/$encodedText';

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translation'];
      } else {
        print("Lỗi API dịch: ${response.statusCode}");
        print("Nội dung trả về: ${response.body}");
        return null;
      }
    } on SocketException {
      print("Không có kết nối mạng.");
      return null;
    } on TimeoutException {
      print("Quá thời gian khi dịch.");
      return null;
    } catch (e) {
      print("Lỗi không xác định khi dịch: $e");
      return null;
    }
  }
}
