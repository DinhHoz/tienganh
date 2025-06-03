class Question {
  final String id;
  final String type;
  final String title;
  final String questionText;
  final String? audioUrl;
  final String correctAnswerId;
  final List<Option> options;
  final String? topic; // Thêm trường topic

  Question({
    required this.id,
    required this.type,
    required this.title,
    required this.questionText,
    this.audioUrl,
    required this.correctAnswerId,
    required this.options,
    this.topic, // Thêm vào constructor
  });

  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      id: data['id'] ?? '',
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      questionText: data['questionText'] ?? '',
      audioUrl: data['audioUrl'],
      correctAnswerId: data['correctAnswerId'] ?? '',
      options: (data['options'] as List<dynamic>)
          .map((option) => Option.fromFirestore(option))
          .toList(),
      topic: data['topic'], // Ánh xạ trường topic
    );
  }
}

class Option {
  final String id;
  final String text;
  final String? imageUrl;

  Option({
    required this.id,
    required this.text,
    this.imageUrl,
  });

  factory Option.fromFirestore(Map<String, dynamic> data) {
    return Option(
      id: data['id'] ?? '',
      text: data['text'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }
}