import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('flutter_logo');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          print('Thông báo được nhấn với payload: ${response.payload}');
        },
      );

      final androidPlugin = notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null &&
          await androidPlugin.areNotificationsEnabled() == false) {
        await androidPlugin.requestNotificationsPermission();
      }

      print('Khởi tạo NotificationService thành công');
    } catch (e) {
      print('Lỗi khởi tạo NotificationService: $e');
      rethrow;
    }
  }

  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel_id',
        'Thông báo theo lịch',
        channelDescription: 'Kênh cho các thông báo được lên lịch',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: 'flutter_logo',
        styleInformation: DefaultStyleInformation(true, true),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    required DateTime scheduledDate,
  }) async {
    try {
      final tz.TZDateTime scheduledNotificationDateTime =
          tz.TZDateTime.from(scheduledDate, tz.local);

      if (scheduledNotificationDateTime.isBefore(tz.TZDateTime.now(tz.local))) {
        throw Exception('Thời gian lên lịch phải nằm trong tương lai');
      }

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledNotificationDateTime,
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      print(
          'Thông báo được lên lịch thành công: ID=$id, Thời gian=$scheduledNotificationDateTime');
    } catch (e) {
      print('Lỗi khi lên lịch thông báo: $e');
      rethrow;
    }
  }

  Future<void> cancelNotification() async {
    try {
      await notificationsPlugin.cancelAll();
      print('Đã hủy tất cả thông báo');
    } catch (e) {
      print('Lỗi khi hủy thông báo: $e');
      rethrow;
    }
  }
}