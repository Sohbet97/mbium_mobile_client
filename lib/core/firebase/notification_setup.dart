import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Admin notifications',
  description: 'New orders',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  sound: RawResourceAndroidNotificationSound('notification'),
);
