import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final Set<String> _handledMessageIds = {};

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('Local notifications initialized');
  }

  static void onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      print('Notification tapped with payload: $payload');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> display(RemoteMessage message) async {
    try {
      final messageId = message.messageId;
      if (messageId != null) {
        if (_handledMessageIds.contains(messageId)) {
          print(
              'LocalNotificationService: Message $messageId already handled, skipping.');
          return;
        }
        _handledMessageIds.add(messageId);

        // Keep the set size manageable
        if (_handledMessageIds.length > 100) {
          _handledMessageIds.remove(_handledMessageIds.first);
        }
      }

      print('LocalNotificationService: Displaying notification...');
      final notification = message.notification;
      final data = message.data;
      final android = message.notification?.android;

      String? title = notification?.title ?? data['title'];
      String? body = notification?.body ?? data['body'];

      if (title != null || body != null) {
        // Use message.messageId hash code or message hash code as ID to ensure it's always an int
        // fallback to current time if both are somehow null
        int notificationId = message.messageId?.hashCode ?? message.hashCode;

        await _notificationsPlugin.show(
          notificationId,
          title,
          body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
              icon: android?.smallIcon ?? '@mipmap/launcher_icon',
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(),
        );
        print('Local notification displayed: $title');
      } else {
        print('LocalNotificationService: Title and body are null');
      }
    } catch (e) {
      print('Error displaying local notification: $e');
    }
  }

  static Future<void> showTestNotification() async {
    try {
      await _notificationsPlugin.show(
        999,
        'اختبار الإشعارات',
        'هذا إشعار تجريبي للتأكد من أن النظام يعمل بشكل صحيح',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('Test notification displayed successfully');
    } catch (e) {
      print('Error displaying test notification: $e');
    }
  }
}
