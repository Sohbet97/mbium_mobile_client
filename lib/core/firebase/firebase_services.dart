import 'package:firebase_messaging/firebase_messaging.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> requestPermission() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Permission status: ${settings.authorizationStatus}');
}

Future<String?> getAdminFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();

  if (token != null) {
    print('🔥 ADMIN FCM TOKEN: $token');
  } else {
    print('❌ Token is null');
  }

  return token;
}
