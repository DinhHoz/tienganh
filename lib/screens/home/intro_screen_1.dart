import 'package:app_tieng_anh/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';
import 'package:app_tieng_anh/screens/home/intro_screen_2.dart';
import 'package:app_tieng_anh/screens/home/home_page.dart';
class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

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
                    'Chào bạn! Tớ là Duo!',
                    style: AppTextStyles.subTitle_1,
                    textAlign: TextAlign.center,
                  ),
                ),

                // Hình ảnh Duo
                Image.asset(
                  'assets/images/duolingo.gif',
                  height: 120,
                ),

                const Spacer(),

                // Nút "Tiếp tục"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ChonLoaiCauHoiScreen(userId: 0,)),
                        (route) => false,
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
