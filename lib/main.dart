import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/network/local_data.dart';
import 'package:dashboard_grow/core/services/local_notification_service.dart';
import 'package:dashboard_grow/core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/Onboarding/splash_screen.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Handling background message: ${message.messageId}');

  await LocalNotificationService.initialize();

  await LocalNotificationService.display(message);
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize APIHelper and wait for it
    APIHelper.init();
    // Initialize LocalData and wait for it
    LocalData.init();

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      print("Initializing Firebase for mobile platform...");

      try {
        await Firebase.initializeApp();
        print("Firebase initialized successfully");

        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        print("Background message handler set");

        await LocalNotificationService.initialize();
        print("Local notifications initialized");

        await NotificationService.instance.init();
        print("NotificationService initialized");
      } catch (e) {
        print("Error during mobile-specific initialization: $e");
      }
    }
  } catch (e) {
    print("Critical error during app startup: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size designSize = constraints.maxWidth < 600
            ? const Size(375, 812)
            : const Size(1440, 900);
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              title: 'Dashboard Grow',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
