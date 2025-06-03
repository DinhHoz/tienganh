import 'package:flutter/material.dart';
import 'package:app_tieng_anh/models/knowledge_quiz_api_question.dart';
import 'package:app_tieng_anh/models/knowledge_quiz_question.dart';

class VocabularyExerciseScreen extends StatefulWidget {
  const VocabularyExerciseScreen({super.key});

  @override
  State<VocabularyExerciseScreen> createState() =>
      _VocabularyExerciseScreenState();
}

class _VocabularyExerciseScreenState extends State<VocabularyExerciseScreen> {
  final ApiService _apiService = ApiService();
  Future<Question>? _questionFuture;
  String? _selectedOptionId;
  bool _isCorrect = false;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() {
    setState(() {
      _questionFuture = _apiService.fetchQuestions(amount: 1).then((list) {
        if (list.isEmpty) throw Exception('Không có câu hỏi nào được trả về');
        return list.first;
      });
      _selectedOptionId = null;
      _showResult = false;
      _isCorrect = false;
    });
  }

  void _onOptionSelected(String optionId) {
    setState(() {
      _selectedOptionId = optionId;
      _showResult = false;
    });
  }

  void _checkAnswer(String correctAnswerId) {
    if (_selectedOptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn một đáp án!')),
      );
      return;
    }

    setState(() {
      _isCorrect = _selectedOptionId == correctAnswerId;
      _showResult = true;
    });

    if (_isCorrect) {
      Future.delayed(const Duration(seconds: 3), () {
        _loadQuestion();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CÂU ĐỐ KIẾN THỨC',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 118, 188, 223),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Question>(
        future: _questionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    snapshot.error.toString().contains('429')
                        ? 'Quá nhiều yêu cầu. Vui lòng đợi một chút.'
                        : 'Lỗi tải câu hỏi: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Thử lại',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final question = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      question.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.questionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                        decorationThickness: 2,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ...question.options.map((option) {
                      final isSelected = _selectedOptionId == option.id;
                      Color borderColor = Colors.transparent;
                      Color bgColor = Colors.grey[100]!;
                      if (_showResult) {
                        if (isSelected) {
                          borderColor = _isCorrect ? Colors.green : Colors.red;
                          bgColor = _isCorrect
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1);
                        } else if (option.id == question.correctAnswerId) {
                          borderColor = Colors.green;
                          bgColor = Colors.green.withOpacity(0.1);
                        }
                      } else if (isSelected) {
                        borderColor = Colors.blue;
                        bgColor = Colors.blue.withOpacity(0.1);
                      }

                      return GestureDetector(
                        onTap: () => _onOptionSelected(option.id),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            option.text,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _checkAnswer(question.correctAnswerId),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        foregroundColor: Colors.white,
                        backgroundColor: _showResult
                            ? (_isCorrect ? Colors.green : Colors.red)
                            : Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_showResult) ...[
                            Icon(
                              _isCorrect ? Icons.check_circle : Icons.cancel,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            _showResult
                                ? (_isCorrect ? 'CHÍNH XÁC!' : 'SAI RỒI!')
                                : 'KIỂM TRA',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showResult && !_isCorrect) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadQuestion,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'CÂU HỎI TIẾP THEO',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Không có dữ liệu câu hỏi.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}