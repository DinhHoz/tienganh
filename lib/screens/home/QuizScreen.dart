import 'dart:math';
import 'package:app_tieng_anh/screens/home/account_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/models/Quiz_question.dart';
import 'package:app_tieng_anh/config/theme.dart'; // import AppColors, AppTextStyles từ đây

class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> allQuestions = [];
  List<Question> currentQuizQuestions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  String? errorMessage;
  String? selectedTopic;
  String? selectedAnswerId;
  bool showResult = false;
  final Random _random = Random();

  final List<String> topics = [
    'Đồ nội thất trong nhà',
    'Thiết bị điện tử',
    'Đồ ăn',
    'Địa điểm',
    'Quốc gia',
    'Thời tiết và cảm xúc',
    'Cơ thể người',
    'Động vật',
    'Nghề nghiệp',
  ];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('questions').get();

      final loadedQuestions = querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc.data()))
          .toList();

      setState(() {
        allQuestions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Lỗi khi tải câu hỏi: $e';
      });
    }
  }

  String getTopicForQuestion(Question q) {
    return (q.topic != null && topics.contains(q.topic))
        ? q.topic!
        : 'Đồ vật khác';
  }

  void startQuizForTopic(String topic) {
    selectedTopic = topic;
    List<Question> filtered =
        allQuestions.where((q) => getTopicForQuestion(q) == topic).toList();
    filtered.shuffle(_random);
    for (var q in filtered) {
      q.options.shuffle(_random);
    }
    setState(() {
      currentQuizQuestions = filtered;
      currentQuestionIndex = 0;
      selectedAnswerId = null;
      showResult = false;
    });
  }

  void checkAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < currentQuizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerId = null;
        showResult = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.green, size: 32),
              const SizedBox(width: 8),
              Text(
                "Hoàn thành",
                style: AppTextStyles.buttonTextGreen.copyWith(
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            "Bạn đã hoàn thành chủ đề $selectedTopic!",
            style: AppTextStyles.subTitle.copyWith(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
         
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => selectedTopic = null);
              },
              child: Text(
                "Chọn chủ đề khác",
                style: AppTextStyles.buttonTextGreen.copyWith(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          
          ],
        ),
      );
    }
  }

  Widget buildOptionButton(String id, String text, {String? imageUrl}) {
    bool isSelected = selectedAnswerId == id;
    bool isCorrect =
        id == currentQuizQuestions[currentQuestionIndex].correctAnswerId;

    Color borderColor = Colors.grey[400]!;
    Color? bgColor = Colors.white;

    if (showResult) {
      if (isCorrect) {
        bgColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
      } else if (isSelected) {
        bgColor = Colors.red.withOpacity(0.2);
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      borderColor = AppColors.buttonGreen;
      bgColor = AppColors.buttonGreen.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () {
        if (!showResult) {
          setState(() {
            selectedAnswerId = id;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Color.fromARGB(255, 105, 102, 102),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              text,
              style: AppTextStyles.buttonTextSecondary.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
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
                errorMessage!,
                style: AppTextStyles.subTitle.copyWith(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loadQuestions,
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
                child: Text(
                  "Thử lại",
                  style: AppTextStyles.buttonTextPrimary.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (selectedTopic == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        
        appBar: AppBar(

          backgroundColor: Colors.grey[100],
          leading: Padding(
            padding: const EdgeInsets.all(1),
            child: SizedBox(
              child: Image.asset('assets/images/duo4.gif', width: 60, height: 60),
            ),
          ),
          title: const Text(
            "Chọn chủ đề",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
      
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: topics.map((topic) {
            return GestureDetector(
              onTap: () => startQuizForTopic(topic),
              child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      topic,
                      style: AppTextStyles.buttonTextGreen.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    final question = currentQuizQuestions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text(
          "${question.title} - $selectedTopic",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            onPressed: () => setState(() => selectedTopic = null),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / currentQuizQuestions.length,
              color: AppColors.buttonGreen,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.questionText,
                  style: AppTextStyles.subTitle_1.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(221, 248, 247, 247),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: question.type == 'image'
                ? GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: question.options
                        .map((opt) => buildOptionButton(opt.id, opt.text,
                            imageUrl: opt.imageUrl))
                        .toList(),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: question.options
                        .map((opt) => buildOptionButton(opt.id, opt.text))
                        .toList(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: showResult ? goToNextQuestion : checkAnswer,
              child: Text(
                showResult ? "TIẾP TỤC" : "KIỂM TRA",
                style: AppTextStyles.buttonTextPrimary.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}