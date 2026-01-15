import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // init timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(
      android: androidInit,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // minta izin notifikasi (Android 13+)
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.dueDate == null) return;

    // kalau dueDate sudah lewat, jangan jadwalkan
    if (task.dueDate!.isBefore(DateTime.now())) return;

    final tzDateTime = tz.TZDateTime.from(task.dueDate!, tz.local);

    final androidDetails = const AndroidNotificationDetails(
      'todo_channel',
      'To-Do Reminders',
      channelDescription: 'Reminder untuk tugas To-Do List',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // bikin id unik berdasarkan waktu
    final id = task.dueDate!.millisecondsSinceEpoch ~/ 1000;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Reminder: ${task.title}',
      task.description ?? 'Cek kembali tugasmu.',
      tzDateTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}

// biar gampang dipakai di mana-mana
final notificationService = NotificationService();
