import 'package:app_tieng_anh/screens/notification/notification_screen.dart';
import 'package:app_tieng_anh/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';

class IntroScreen1 extends StatelessWidget {
  const IntroScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo NotificationService (hoặc nhận từ Navigator nếu cần)
    final notificationService = NotificationService();

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
                      color: AppColors.dialogBorder,
                      width: 1.5,
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
                    onPressed: () async {
                      // Khởi tạo NotificationService trước khi điều hướng
                      await notificationService.initNotification();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(
                            notificationService: notificationService,
                          ),
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