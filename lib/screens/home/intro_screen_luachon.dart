import 'package:flutter/material.dart';
import 'package:app_tieng_anh/config/theme.dart';
import 'package:app_tieng_anh/screens/home/intro_srceen_StudyPlan.dart';
class ReasonSelectionScreen extends StatefulWidget {
  @override
  _ReasonSelectionScreenState createState() => _ReasonSelectionScreenState();
}

class _ReasonSelectionScreenState extends State<ReasonSelectionScreen> {
  final List<_ReasonItem> reasons = [
    _ReasonItem(' Sử dụng thời gian hiệu quả'),
    _ReasonItem(' Giải trí'),
    _ReasonItem(' Phát triển sự nghiệp'),
    _ReasonItem(' Chuẩn bị đi du lịch'),
    _ReasonItem(' Hỗ trợ việc học tập'),
    _ReasonItem(' Kết nối với mọi người'),
    _ReasonItem(' Khác'),
  ];

  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Nút quay lại + Thanh tiến độ
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.backIcon),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: _buildProgressBar()),
                ],
              ),
              const SizedBox(height: 20),

              // Duo + Câu hỏi
              Row(
                children: const [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/duo3.gif'),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Tại sao bạn học Tiếng Anh?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Danh sách lý do
              ...reasons.asMap().entries.map((entry) {
                int index = entry.key;
                _ReasonItem reason = entry.value;
                bool isSelected = selectedIndexes.contains(index);
                return _buildReasonTile(index, reason, isSelected);
              }),

              const Spacer(),

              // Nút tiếp tục
              Opacity(
                opacity: selectedIndexes.isNotEmpty ? 1.0 : 0.5,
                child: ElevatedButton(
                  onPressed: selectedIndexes.isNotEmpty ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'TIẾP TỤC',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: 0.2,
        backgroundColor: Colors.white12,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonGreen),
        minHeight: 8,
      ),
    );
  }

  Widget _buildReasonTile(int index, _ReasonItem item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIndexes.remove(index);
          } else {
            selectedIndexes.add(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.buttonGreen : AppColors.dialogBorder,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? AppColors.buttonGreen : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    // Thao tác sau khi chọn xong
    // print("Đã chọn: ${selectedIndexes.map((i) => reasons[i].label)}");
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const StudyPlanScreen()),
  );
  }
}

class _ReasonItem {
  final String label;
  _ReasonItem(this.label);
}
