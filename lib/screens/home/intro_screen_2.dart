import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';
import 'package:app_tieng_anh/screens/home/intro_screen_3.dart';
class IntroScreen2 extends StatelessWidget {
  const IntroScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Nút quay lại
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.backIcon),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            // Nội dung chính
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Hộp thoại
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.dialogBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.dialogBorder, // dùng màu từ theme
                      width: 1.5, // độ dày viền
                    ),
                  ),
                  child: const Text(
                    'Hãy trả lời 7 câu hỏi nhỏ\ntrước khi bắt đầu bài học\nnhé!',
                    style: AppTextStyles.subTitle_1,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Hình ảnh Duo
                Image.asset('assets/images/duo3.gif', height: 150),

                const Spacer(),

                // Nút "Tiếp tục"
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Chuyển sang màn hình tiếp theo
                      Navigator.push(
                        context,
                         MaterialPageRoute(
                          builder: (context) => LevelSelectionScreen(),
                          ),
                      );
                    },
                    child: const Text(
                      'TIẾP TỤC',
                      style: AppTextStyles.buttonTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
