import 'dart:developer';
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
      log("Firebase Messaging not supported on this platform");
      return;
    }

    try {
      _messaging = FirebaseMessaging.instance;
      log("NotificationService: Initializing...");

      await requestPermission();

      String? token = await _messaging?.getToken();
      if (token != null) {
        log("FCM Token: $token");
        if (LocalData.accessToken != null) {
          log("Syncing FCM token with backend...");
          await syncToken(token);
        } else {
          log("No access token, will sync FCM token after login");
        }
      } else {
        log("Failed to get FCM token");
      }

      _messaging?.onTokenRefresh.listen((newToken) {
        log("FCM Token Refreshed: $newToken");
        syncToken(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');
        log('Message notification: ${message.notification?.title} - ${message.notification?.body}');
        LocalNotificationService.display(message);
      });

      RemoteMessage? initialMessage = await _messaging?.getInitialMessage();
      if (initialMessage != null) {
        log('App opened from terminated state via notification!');
        log('Initial message data: ${initialMessage.data}');
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Message clicked!');
        log('Data: ${message.data}');
      });

      log("NotificationService: Initialization complete");
    } catch (e) {
      log("Error initializing Firebase Messaging: $e");
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
      log("Error requesting permission: $e");
    }
  }

  Future<void> syncToken(String? token) async {
    if (token == null) return;

    log("NotificationService: Sending token to backend: $token");
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
        log("FCM Token synced successfully: ${response.message}");
      } else {
        log("Failed to sync FCM token: ${response.message}");
      }
    } catch (e) {
      log("Error syncing FCM token: $e");
    }
  }

  Future<String?> getToken() async {
    if (!_isSupported || _messaging == null) {
      log("Firebase not initialized or not supported");
      return null;
    }

    try {
      return await _messaging?.getToken();
    } catch (e) {
      log("Error getting token: $e");
      return null;
    }
  }

  Future<void> syncCurrentToken() async {
    if (!_isSupported) {
      log("FCM not supported on this platform");
      return;
    }

    try {
      final token = await getToken();
      if (token != null) {
        await syncToken(token);
      }
    } catch (e) {
      log("Error syncing token: $e");
    }
  }
}
