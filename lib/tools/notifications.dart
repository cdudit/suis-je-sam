import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Demande d'affichage de notifications
  _requestIOSPermission() {
    if (flutterLocalNotificationsPlugin == null) {
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    }
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  /// Initialisation des plateformes
  _initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_notf_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  /// Envoie d'une notification
  Future<void> showNotification() async {
    _requestIOSPermission();
    _initializePlatformSpecifics();
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Test Title', // Notification Title
      'Test Body', // Notification Body, set as null to remove the body
      platformChannelSpecifics// Notification Payload
    );
  }
}
