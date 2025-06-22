import 'package:flutter/material.dart';
import 'package:app_tieng_anh/services/notification_service.dart';
import 'package:app_tieng_anh/screens/auth/login_screen.dart';

class NotificationScreen extends StatefulWidget {
  final NotificationService notificationService;

  const NotificationScreen({required this.notificationService, super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TimeOfDay? _selectedTime;

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFa1c4fd), Color(0xFFc2e9fb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hình minh họa
                  Image.asset(
                    'assets/images/avatar1.png', // Thay bằng ảnh phù hợp
                    height: 120,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Lên lịch học mỗi ngày!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 2, 163, 238),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn thời gian để nhắc bạn học tiếng Anh mỗi ngày.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: const Color.fromARGB(255, 102, 101, 101) ,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Nút chọn thời gian
                  ElevatedButton(
                    onPressed: () => _pickTime(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 44, 127, 252),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      _selectedTime == null
                          ? 'Chọn thời gian thông báo'
                          : 'Thời gian: ${_selectedTime!.format(context)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nút lên lịch thông báo
                  ElevatedButton(
                    onPressed: _selectedTime == null
                        ? null
                        : () async {
                            try {
                              final now = DateTime.now();
                              final scheduledDate = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                _selectedTime!.hour,
                                _selectedTime!.minute,
                              );

                              final finalScheduledDate = scheduledDate.isBefore(now)
                                  ? scheduledDate.add(const Duration(days: 1))
                                  : scheduledDate;

                              await widget.notificationService.scheduleNotification(
                                id: 1,
                                title: 'Đừng quên học tiếng Anh!',
                                body: 'Nâng cấp tiếng Anh đi thôi nào!',
                                scheduledDate: finalScheduledDate,
                                payload: 'daily_notification_1',
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: $e')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 105, 243, 176),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Lên lịch thông báo',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nút huỷ
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await widget.notificationService.cancelNotification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Đã huỷ tất cả thông báo!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Huỷ thông báo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
