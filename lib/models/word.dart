import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

class Sense {
  final int senseIndex;
  final String definition;
  final List<String> examples;

  Sense({
    required this.senseIndex,
    required this.definition,
    required this.examples,
  });

  factory Sense.fromJson(Map<String, dynamic> json) {
    return Sense(
      senseIndex: json['sense_index'],
      definition: json['definition'],
      examples: List<String>.from(json['examples']),
    );
  }
}

class Word {
  final String word;
  final String level;
  final String pos;
  final String usAudio;
  final String ukAudio;
  final String usPhonetic; // mới
  final String ukPhonetic; // mới
  final List<Sense> senses;

  Word({
    required this.word,
    required this.level,
    required this.pos,
    required this.usAudio,
    required this.ukAudio,
    required this.usPhonetic, // mới
    required this.ukPhonetic, // mới
    required this.senses,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'],
      level: json['level'],
      pos: json['pos'],
      usAudio: json['us_audio'],
      ukAudio: json['uk_audio'],
      usPhonetic: json['us_phonetic'], // mới
      ukPhonetic: json['uk_phonetic'], // mới
      senses: List<Sense>.from(json['senses'].map((x) => Sense.fromJson(x))),
    );
  }
}

Future<List<Word>> loadAllWordsFromList() async {
  List<Word> words = [];

  try {
    // Đọc danh sách tên file từ list_words.json
    final String listJson = await rootBundle.loadString(
      'assets/data/list_words.json',
    );
    final List<dynamic> filenames = json.decode(listJson);

    for (var file in filenames) {
      try {
        final wordsInFile = await loadWordsFromAsset(file);
        words.addAll(wordsInFile);
      } catch (e) {
        print("Không thể load file: $file — lỗi: $e");
      }
    }
  } catch (e) {
    print('Lỗi khi đọc list_words.json: $e');
  }

  return words;
}

Future<List<Word>> loadWordsFromAsset(String filename) async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/$filename',
  );
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((jsonItem) => Word.fromJson(jsonItem)).toList();
}
