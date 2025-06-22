import 'package:app_tieng_anh/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/screens/quiz/QuizScreen.dart';
import 'package:app_tieng_anh/screens/quiz/knowledge_quiz_screen.dart';
import 'package:app_tieng_anh/screens/dictionary/dictionary_screen.dart';
import 'package:app_tieng_anh/screens/quiz/list_words_screen.dart';
import 'package:app_tieng_anh/screens/auth/user_profile.dart';

// Màn hình chọn loại câu hỏi với thiết kế SlideShow
class ChonLoaiCauHoiScreen extends StatelessWidget {
  final int userId;
  const ChonLoaiCauHoiScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize =
        screenWidth * 0.6; 
    // Danh sách bài học cho bài trình chiếu
    final List<Map<String, dynamic>> lessons = [
      {
        'title': 'Bài Học 1',
        'subtitle': 'Câu hỏi kiến thức trắc nghiệm',
        'destination': const VocabularyExerciseScreen(),
      },
      {
        'title': 'Bài Học 2',
        'subtitle': 'Câu hỏi trắc nghiệm từ vựng theo chủ đề ',
        'destination': QuizScreen(),
      },
      {
        'title': 'Bài Học 3',
        'subtitle': 'Dịch và tra từ điển',
        'destination': DictionaryScreen(),
      },
      {
        'title': 'Bài Học 4',
        'subtitle': 'Tạo bài học từ vựng',
        'destination': WordListScreen(userId: userId),
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300, // Màu xanh da trời 
              const Color.fromARGB(
                255,
                247,
                246,
                246,
              ), // White at the bottom (from updated AppColors)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Thanh trên cùng với tiến trình, mục tiêu hàng ngày, chuỗi và cấp độ
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Image.asset(
                      'assets/images/top-rated.png', 
                      width: 40, 
                      height: 40,
                    

                      colorBlendMode: BlendMode.modulate,
                    ),
                    // Mục tiêu hàng ngày
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 118, 188, 223),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 118, 188, 223),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: const Color.fromARGB(255, 239, 240, 232),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Mục tiêu: 10 phút",
                            style: AppTextStyles.subTitle_1.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Earth icon (placeholder)
                    Image.asset(
                      'assets/images/earth.png', 
                      width: 40, 
                      height: 40,
        
 
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ],
                ),
              ),
              // Chuỗi và cấp độ hàng ngày
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 118, 188, 223),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 118, 188, 223),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 118, 188, 223),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromARGB(255, 118, 188, 223),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Main content with slideshow
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                        'assets/images/duo4.gif', 
                        width: 180, 
                        height: 180,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Bắt đầu bài học của bạn",
                        style: AppTextStyles.appName.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      
                    ),
                    const SizedBox(height: 20),
                    // Trình chiếu sử dụng PageView
                    SizedBox(
                      height:
                          buttonSize + 40, 
                      child: PageView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return Stack(
                            children: [
                              // Nút bài học
                              Center(
                                child: _buildCustomButton(
                                  context: context,
                                  buttonSize: buttonSize,
                                  title: lesson['title'],
                                  subtitle: lesson['subtitle'],
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => lesson['destination'],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Left arrow
                              if (index > 0)
                                Positioned(
                                  left: 10,
                                  top: buttonSize / 2,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_left,
                                      size: 50,
                                      color: const Color.fromARGB(
                                        255,
                                        51,
                                        189,
                                        23,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              // Right arrow
                              if (index < lessons.length - 1)
                                Positioned(
                                  right: 10,
                                  top: buttonSize / 2,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_right,
                                      size: 50,
                                      color: const Color.fromARGB(
                                        255,
                                        51,
                                        189,
                                        23,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom navigation bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                color: AppColors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Optional: Circular image
                          color: AppColors.buttonGreen.withOpacity(0.2), // Optional: Background
                        ),
                        child: Image.asset(
                          'assets/images/home.png', // Replace with your image path
                          width: 24, // Slightly smaller to fit within container
                          height: 24,
                          color: AppColors.buttonGreen,
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                      onPressed: () {
                        // Already on ChonLoaiCauHoiScreen (home), so no action or pop to root
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                    ),
                    IconButton(
                      icon: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Optional: Circular image
                          // color: AppColors.buttonGreen.withOpacity(0.2), // Optional: Background
                        ),
                        child: Image.asset(
                          'assets/images/user.png', // Replace with your image path
                          width: 24, // Slightly smaller to fit within container
                          height: 24,
                          color: AppColors.buttonGreen,
                          colorBlendMode: BlendMode.modulate,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserProfilePage(userId: userId)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom button widget with dynamic size
  Widget _buildCustomButton({
    required BuildContext context,
    required double buttonSize,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.purple.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppTextStyles.subTitle_1.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppTextStyles.appName.copyWith(
                    fontSize: 20,
                    color: AppColors.whiteText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.star,
                        size: 20,
                        color: AppColors.subText_2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteText,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "Bắt đầu",
                    style: AppTextStyles.buttonTextPrimary.copyWith(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
