import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';

class StudyPlanScreen_1 extends StatefulWidget {
  const StudyPlanScreen_1({Key? key}) : super(key: key);

  @override
  State<StudyPlanScreen_1> createState() => _StudyPlanScreen_1State();
}

class _StudyPlanScreen_1State extends State<StudyPlanScreen_1> {
  int? _selectedIndex;

  final List<Map<String, String>> goals = [
    {'time': '3 phút / ngày', 'level': 'Dễ'},
    {'time': '10 phút / ngày', 'level': 'Vừa'},
    {'time': '15 phút / ngày', 'level': 'Khó'},
    {'time': '30 phút / ngày', 'level': 'Siêu khó'},
  ];

  void _onCommit() {
    if (_selectedIndex != null) {
      debugPrint("Bạn đã chọn: ${goals[_selectedIndex!]['time']}");
      // TODO: Chuyển sang màn tiếp theo nếu có
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32), // Cách viền trên
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48, // Tăng chiều cao tổng thể cho hàng
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.backIcon),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 10, // Dày hơn
                        child: LinearProgressIndicator(
                          value: 0.50,
                          color: AppColors.buttonGreen,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image.asset(
                  'assets/images/duo3.gif',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Mục tiêu hằng ngày của bạn là gì nhỉ?',
                    style: AppTextStyles.subTitle_1,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            for (int index = 0; index < goals.length; index++)
              _buildGoalCard(index),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _onCommit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedIndex != null
                      ? AppColors.buttonGreen
                      : Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'TÔI QUYẾT TÂM',
                  style: AppTextStyles.buttonTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(int index) {
    final goal = goals[index];
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.buttonGreen
                : AppColors.button_border_1,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              goal['time']!,
              style: AppTextStyles.buttonTextSecondary.copyWith(color: Colors.white),
            ),
            Text(
              goal['level']!,
              style: AppTextStyles.subTitle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
