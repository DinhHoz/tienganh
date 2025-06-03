import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';


class BasicLessonScreen extends StatelessWidget {
  const BasicLessonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            //  Back + thanh tiến độ trong cùng một hàng
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.backIcon, // hoặc Colors.black
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.dialogBorder,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.35, // Tùy chỉnh phần trăm tiến độ
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.buttonGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Icon + hội thoại
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/duo3.gif', // Thay bằng ảnh bạn thêm vào assets
                    height: 120,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dialogBackground,
                        border: Border.all(color: AppColors.dialogBorder),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Được rồi, mình cùng học từ cơ bản nhé!',
                        style: AppTextStyles.subTitle_1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Nút "TIẾP TỤC"
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: xử lý khi bấm tiếp tục
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  minimumSize: const Size(320, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'TIẾP TỤC',
                  style: AppTextStyles.buttonTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
