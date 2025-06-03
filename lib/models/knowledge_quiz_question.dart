import 'package:html_unescape/html_unescape.dart';

class Question {
  final String title;
  final String questionText;
  final String audioUrl;
  final String correctAnswerId;
  final List<Option> options;

  Question({
    required this.title,
    required this.questionText,
    required this.audioUrl,
    required this.correctAnswerId,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    final correctText = json['correct_answer'];
    final incorrectAnswers = List<String>.from(json['incorrect_answers']);
    final allAnswers = [correctText, ...incorrectAnswers]..shuffle();

    final options = allAnswers.asMap().entries.map((entry) {
      return Option(id: (entry.key + 1).toString(), text: entry.value);
    }).toList();

    final correctOption = options.firstWhere((option) => option.text == correctText);

    return Question(
      title: unescape.convert(json['category'] ?? ''),
      questionText: unescape.convert(json['question'] ?? ''),
      audioUrl: '',
      correctAnswerId: correctOption.id,
      options: options,
    );
  }
}

class Option {
  final String id;
  final String text;

  Option({required this.id, required this.text});
}