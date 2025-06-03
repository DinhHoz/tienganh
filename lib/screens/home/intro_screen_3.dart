import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';


class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int? selectedIndex;

  final List<String> levels = [
    'Tôi mới học Tiếng Anh',
    'Tôi biết một vài từ thông dụng',
    'Tôi có thể giao tiếp cơ bản',
    'Tôi có thể nói về nhiều chủ đề',
    'Tôi có thể thảo luận sâu về hầu hết các chủ đề',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Back button + progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.backIcon,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.2,
                      backgroundColor: AppColors.dialogBackground,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.buttonGreen,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Duo + message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/duo3.gif',
                    height: 80,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dialogBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.dialogBorder),
                      ),
                      child: const Text(
                        'Trình độ Tiếng Anh của bạn ở mức nào?',
                        style: AppTextStyles.subTitle_1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List options with signal bars
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: levels.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.dialogBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.buttonGreen : AppColors.button_border_1,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildSignalBar(index + 1),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              levels[index],
                              style: AppTextStyles.subTitle_1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ElevatedButton(
                onPressed: selectedIndex != null
                    ? () {
                        final selectedLevel = levels[selectedIndex!];
                        // TODO: Lưu vào SQLite hoặc chuyển trang
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedIndex != null ? AppColors.buttonGreen : AppColors.dialogBackground,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'TIẾP TỤC',
                  style: selectedIndex != null
                      ? AppTextStyles.buttonTextPrimary
                      : AppTextStyles.buttonTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignalBar(int level) {
    return Row(
      children: List.generate(5, (index) {
        final isFilled = index < level;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 5,
          height: 10 + index * 4,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.buttonGreen : AppColors.button_border_1,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
} 
