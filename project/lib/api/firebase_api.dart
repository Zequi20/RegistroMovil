import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FireBaseApi {
  final fireBaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await fireBaseMessaging.requestPermission();
    final fCMToken = await fireBaseMessaging.getToken();

    print('Token: $fCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
