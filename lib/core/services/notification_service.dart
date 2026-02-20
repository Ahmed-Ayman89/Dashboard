import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/network/local_data.dart';
import 'package:dashboard_grow/core/services/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  static NotificationService get instance => _instance;

  NotificationService._internal();

  FirebaseMessaging? _messaging;

  bool get _isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (!_isSupported) {
      print("Firebase Messaging not supported on this platform");
      return;
    }

    try {
      _messaging = FirebaseMessaging.instance;
      print("NotificationService: Initializing...");

      await requestPermission();

      String? token = await _messaging?.getToken();
      if (token != null) {
        print("FCM Token: $token");
        // Save token locally for reliable access
        await LocalData.saveRegistrationToken(token);

        if (LocalData.accessToken != null) {
          print("Syncing FCM token with backend...");
          // Don't await syncToken to avoid stalling app initialization
          syncToken(token);
        } else {
          print("No access token, will sync FCM token after login");
        }
      } else {
        print("Failed to get FCM token");
      }

      _messaging?.onTokenRefresh.listen((newToken) {
        print("FCM Token Refreshed: $newToken");
        syncToken(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print(
            'Message notification: ${message.notification?.title} - ${message.notification?.body}');

        // If the message has a notification payload AND the app is in the foreground,
        // we show it manually. However, if the user reports double notifications,
        // it might be because the backend is sending a separate data message or
        // the system is showing it anyway. For now, deduplication in LocalNotificationService
        // should handle the duplicate messageId case.
        LocalNotificationService.display(message);
      });

      RemoteMessage? initialMessage = await _messaging?.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from terminated state via notification!');
        print('Initial message data: ${initialMessage.data}');
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked!');
        print('Data: ${message.data}');
      });

      print("NotificationService: Initialization complete");
    } catch (e) {
      print("Error initializing Firebase Messaging: $e");
    }
  }

  Future<void> requestPermission() async {
    if (!_isSupported || _messaging == null) return;

    try {
      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      print("Error requesting permission: $e");
    }
  }

  Future<void> syncToken(String? token) async {
    if (token == null) return;

    print("NotificationService: Sending token to backend: $token");
    try {
      final response = await APIHelper().postRequest(
        endPoint: EndPoints.fcmToken,
        isFormData: false,
        data: {
          "token": token,
          "platform": defaultTargetPlatform == TargetPlatform.android
              ? "android"
              : "ios"
        },
      );

      if (response.isSuccess) {
        print("FCM Token synced successfully: ${response.message}");
      } else {
        print("Failed to sync FCM token: ${response.message}");
      }
    } catch (e) {
      print("Error syncing FCM token: $e");
    }
  }

  Future<String?> getToken() async {
    if (!_isSupported || _messaging == null) {
      print("Firebase not initialized or not supported");
      return null;
    }

    try {
      String? token = await _messaging?.getToken();
      print("NotificationService: getToken result: $token");
      return token;
    } catch (e) {
      print("Error getting token: $e");
      print(
          "CRITICAL: FCM getToken failed: $e"); // Ensure this prints to console
      return null;
    }
  }

  Future<void> syncCurrentToken() async {
    if (!_isSupported) {
      print("FCM not supported on this platform");
      return;
    }

    try {
      final token = await getToken();
      if (token != null) {
        await syncToken(token);
      } else {
        print("syncCurrentToken: Token is null, cannot sync.");
      }
    } catch (e) {
      print("Error syncing token: $e");
    }
  }
}
