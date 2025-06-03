import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart'; // file chứa AppColors, AppTextStyles, AppTheme

class VocabularyQuestionScreen extends StatefulWidget {
  const VocabularyQuestionScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyQuestionScreen> createState() => _VocabularyQuestionScreenState();
}

class _VocabularyQuestionScreenState extends State<VocabularyQuestionScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> options = [
    {'label': 'sữa', 'icon': Icons.local_drink},
    {'label': 'nước', 'icon': Icons.water},
    {'label': 'cà phê', 'icon': Icons.coffee},
    {'label': 'trà', 'icon': Icons.emoji_food_beverage},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back + progress bar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.backIcon),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const SizedBox(
                      height: 10,
                      child: LinearProgressIndicator(
                        value: 0.25,
                        color: AppColors.buttonGreen,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            const Text('🟣  TỪ VỰNG MỚI', style: TextStyle(color: AppColors.subText_1)),
            const SizedBox(height: 8),
            const Text('Chọn hình ảnh đúng', style: TextStyle(fontSize: 20, color: AppColors.whiteText, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Audio + từ
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.volume_up, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'coffee',
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 18, decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4 lựa chọn
            Expanded(
              child: GridView.builder(
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final item = options[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.dialogBackground,
                        border: Border.all(
                          color: isSelected ? AppColors.buttonGreen : AppColors.dialogBorder,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item['icon'], size: 48, color: Colors.white),
                          const SizedBox(height: 12),
                          Text(item['label'], style: AppTextStyles.subTitle_1),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Nút kiểm tra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex != null ? () {
                  // Xử lý khi kiểm tra
                  final answer = options[selectedIndex!]['label'];
                  debugPrint('Đáp án đã chọn: $answer');
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  foregroundColor: AppColors.blackText,
                  disabledBackgroundColor: AppColors.dialogBorder,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('KIỂM TRA', style: AppTextStyles.buttonTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
