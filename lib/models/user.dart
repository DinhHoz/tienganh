class Users {
  final int id;
  final String name;
  final String username;
  final String email;
  final String password;
  final String avatarUrl;
  final int streakDays;
  final DateTime startDate;
  final int wordsLearned;
  final List<String> learnedWords;

  Users({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.streakDays,
    required this.startDate,
    required this.wordsLearned,
    required this.learnedWords,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: int.parse(json['id'].toString()), // Chuyển đổi an toàn từ String sang int
      name: json['name']?.toString() ?? '', // Đảm bảo không null
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      streakDays: int.tryParse(json['streak_days'].toString()) ?? 0, // Chuyển đổi an toàn
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      wordsLearned: int.tryParse(json['words_learned'].toString()) ?? 0, // Chuyển đổi an toàn
      learnedWords: json['learned_words'] != null && json['learned_words'] is List
          ? List<String>.from(json['learned_words'].map((word) => word.toString()))
          : [],
    );
  }
}