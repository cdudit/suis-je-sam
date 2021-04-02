import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationPlugin() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  }

  /// Demande d'affichage de notifications
  _requestIOSPermission() {
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
        AndroidInitializationSettings('logo_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Envoie d'une notification
  Future<void> showNotification(int seconds) async {
    // On désactive les précédentes notifications
    cancelNotifications();

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
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);

    var scheduleNotificationDateTime =
        DateTime.fromMillisecondsSinceEpoch(seconds);

    // Initialisation des UTC et date en fonction de Paris
    tzData.initializeTimeZones();
    final location = tz.getLocation('Europe/Paris');
    final scheduleDateTime =
        tz.TZDateTime.from(scheduleNotificationDateTime, location);

    await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Vous pouvez de nouveau conduire',
        'Utilisez un alcootest par précaution', scheduleDateTime, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
