import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart'; // Đảm bảo file này chứa AppColors & AppTextStyles

class StudyResultScreen extends StatelessWidget {
  const StudyResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back icon + progress bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.backIcon,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Quay lại màn hình trước
                    },
                  ),
                  
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 10,
                        child: const LinearProgressIndicator(
                          value: 0.53,
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
              const Text(
                'Đây là những thành quả bạn có thể đạt được sau 3 tháng học tập!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteText,
                ),
              ),
              const SizedBox(height: 35),

              // Goal items
              _buildResultItem(
                icon: Icons.chat_bubble_outline,
                iconColor: Colors.purpleAccent,
                title: 'Tự tin giao tiếp',
                subtitle: 'Các bài học nói và nghe không hề áp lực',
              ),
              const SizedBox(height: 35),
              _buildResultItem(
                icon: Icons.auto_stories_outlined,
                iconColor: Colors.lightBlue,
                title: 'Xây dựng vốn từ',
                subtitle: 'Các từ vựng phổ biến và cụm từ thiết thực',
              ),
              const SizedBox(height: 35),
              _buildResultItem(
                icon: Icons.emoji_events_outlined,
                iconColor: Colors.orangeAccent,
                title: 'Tạo thói quen học tập',
                subtitle:
                    'Nhắc nhở thông minh, thử thách vui nhộn và còn nhiều tính năng thú vị khác',
              ),

              const Spacer(),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Chuyển sang màn tiếp theo
                  },
                  child: const Text(
                    'TIẾP TỤC',
                    style: AppTextStyles.buttonTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: iconColor,
          radius: 20,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppColors.whiteText,
                ),
              ),
              const SizedBox(height: 5),
              Text(subtitle, style: AppTextStyles.subTitle_1),
            ],
          ),
        ),
      ],
    );
  }
}
