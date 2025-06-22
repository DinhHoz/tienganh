import 'package:app_tieng_anh/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';
import 'package:app_tieng_anh/screens/home/intro_screen_1.dart';
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('assets/images/duo2.gif', height: 200),
            const SizedBox(height: 30),
            const Text(
              'duolingo',
              style: AppTextStyles.appName,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Cách học ngoại ngữ vui nhộn',
                textAlign: TextAlign.center,
                style: AppTextStyles.subTitle,
              ),
            ),
            const Spacer(),

            // Nút "Bắt đầu ngay"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntroScreen1(),
                    ),
                  );
                },
                child: const Text(
                  'BẮT ĐẦU NGAY',
                  style: AppTextStyles.buttonTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nút "Tôi đã có tài khoản"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dialogBackground,
                  side: const BorderSide(color: AppColors.button_border_1),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
                },
                child: const Text(
                  'TÔI ĐÃ CÓ TÀI KHOẢN',
                  style: AppTextStyles.buttonTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
