import 'package:flutter/material.dart';
import '../../models/word.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/word_api.dart';
import 'dart:math';

enum QuizType { audioToWord, definitionToWord, wordToDefinition }

class LessonScreen extends StatefulWidget {
  final List<Word> selectedWords;
  final List<int> selectedIndices;
  final int userId;

  const LessonScreen({
    super.key,
    required this.selectedWords,
    required this.selectedIndices,
    required this.userId,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final AudioPlayer _player = AudioPlayer();
  List<int> learnedWordIds = [];
  int currentQuestionIndex = 0;
  QuizType currentQuizType = QuizType.audioToWord;
  List<Word> answerOptions = [];
  Word? correctWord;
  Word? selectedWord;
  bool isCorrect = false;
  bool showResult = false;
  int correctAnswers = 0;
  List<Map<String, dynamic>> questions = [];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    fetchLearnedWords();
    generateQuestions();
  }

  void fetchLearnedWords() async {
    final ids = await WordApi.getLearnedWords(widget.userId);
    setState(() {
      learnedWordIds = ids;
    });
  }

  void generateQuestions() {
    questions.clear();
    for (var word in widget.selectedWords) {
      questions.add({'word': word, 'type': QuizType.audioToWord});
      questions.add({'word': word, 'type': QuizType.definitionToWord});
      questions.add({'word': word, 'type': QuizType.wordToDefinition});
    }
    questions.shuffle(random);
    if (questions.length > 2) {
      questions = questions.sublist(0, 2);
    }
    generateAnswerOptions();
  }

  void generateAnswerOptions() {
    if (currentQuestionIndex >= questions.length) return;
    correctWord = questions[currentQuestionIndex]['word'];
    answerOptions = [correctWord!];

    var otherWords =
        widget.selectedWords
            .where((w) => w.word != correctWord!.word) // So sánh theo nội dung
            .toList();

    otherWords.shuffle(random);
    answerOptions.addAll(otherWords.take(3));
    answerOptions.shuffle(random);

    setState(() {
      showResult = false;
      isCorrect = false;
      selectedWord = null;
    });
  }

  void _playAudio(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$assetPath'));
    } catch (e) {
      print('Không thể phát âm thanh: $e');
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Lỗi'),
              content: Text('Không thể phát âm thanh: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  void _markAllAsLearned() async {
    try {
      final success = await WordApi.markAllLearnedWords(
        widget.userId,
        widget.selectedIndices,
      );

      if (success) {
        setState(() {
          for (var index in widget.selectedIndices) {
            final wordId = index + 1;
            if (!learnedWordIds.contains(wordId)) {
              learnedWordIds.add(wordId);
            }
          }
        });

        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Thành công'),
                content: const Text('Đã đánh dấu tất cả từ là đã học'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        _showErrorDialog('Không thể đánh dấu từ. Vui lòng thử lại.');
      }
    } catch (e) {
      _showErrorDialog('Lỗi khi đánh dấu từ: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Lỗi'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void checkAnswer(Word selected) {
    setState(() {
      showResult = true;
      selectedWord = selected;
      isCorrect = selected == correctWord;
      if (isCorrect) {
        correctAnswers++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        generateAnswerOptions();
      });
    } else if (correctAnswers == questions.length) {
      _markAllAsLearned();
    } else {
      setState(() {
        currentQuestionIndex = 0;
        correctAnswers = 0;
        questions.shuffle(random);
        generateAnswerOptions();
      });
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Chưa hoàn thành'),
              content: const Text('Bạn chưa trả lời đúng hết. Làm lại từ đầu!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedWords.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bài học từ vựng')),
        body: const Center(child: Text('Không có từ nào được chọn')),
      );
    }

    if (currentQuestionIndex >= questions.length) {
      return const SizedBox();
    }

    final currentQuestion = questions[currentQuestionIndex];
    final currentWord = currentQuestion['word'] as Word;
    final quizType = currentQuestion['type'] as QuizType;

    String questionText = '';
    Widget? questionWidget;

    switch (quizType) {
      case QuizType.audioToWord:
        questionText = 'Nghe âm thanh và chọn từ đúng:';
        questionWidget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.volume_up),
              label: const Text('US'),
              style: TextButton.styleFrom(foregroundColor: Colors.indigo[300]),
              onPressed: () => _playAudio(currentWord.usAudio),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: const Icon(Icons.volume_up_outlined),
              label: const Text('UK'),
              style: TextButton.styleFrom(foregroundColor: Colors.indigo[300]),
              onPressed: () => _playAudio(currentWord.ukAudio),
            ),
          ],
        );
        break;
      case QuizType.definitionToWord:
        questionText = 'Chọn từ đúng với định nghĩa sau:';
        questionWidget = Text(
          currentWord.senses.isNotEmpty
              ? currentWord.senses[0].definition
              : 'Không có định nghĩa',
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        );
        break;
      case QuizType.wordToDefinition:
        questionText = 'Chọn định nghĩa đúng cho từ: "${currentWord.word}"';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học từ vựng'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Câu ${currentQuestionIndex + 1}/${questions.length} | Đúng: $correctAnswers',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (questionWidget != null) questionWidget,
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children:
                    answerOptions.map((option) {
                      final isCorrectOption = option == correctWord;
                      final isSelected = option == selectedWord;

                      Color backgroundColor;
                      if (showResult) {
                        if (isCorrectOption) {
                          backgroundColor = Colors.green;
                        } else if (isSelected) {
                          backgroundColor = Colors.red;
                        } else {
                          backgroundColor = Colors.grey;
                        }
                      } else {
                        backgroundColor = Colors.blue;
                      }

                      return OutlinedButton(
                        onPressed:
                            showResult ? null : () => checkAnswer(option),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            backgroundColor,
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                              ),
                        ),
                        child: Text(
                          quizType == QuizType.wordToDefinition
                              ? (option.senses.isNotEmpty
                                  ? option.senses[0].definition
                                  : 'Không có định nghĩa')
                              : option.word,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
              ),
            ),

            if (showResult)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    Text(
                      isCorrect
                          ? 'Chính xác! Bạn đã chọn đúng đáp án!'
                          : 'Sai rồi! Đáp án đúng là: "${correctWord!.word}"',
                      style: TextStyle(
                        fontSize: 16,
                        color: isCorrect ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Tiếp tục'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
