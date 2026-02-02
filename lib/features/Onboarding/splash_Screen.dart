import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/network/local_data.dart';
import '../dashboard/presentation/pages/dashboard_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    _startSplash();
  }

  void _startSplash() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    if (LocalData.accessToken != null && LocalData.accessToken!.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          /// Logo center
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SvgPicture.asset(
                'assets/onboarding/mainlogo.svg',
                width: 70.w,
                height: 64.h,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),

          /// Bottom text
          Positioned(
            bottom: 80.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Powered by',
                    style: TextStyle(
                      color: AppColors.neutral500,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SvgPicture.asset(
                    'assets/onboarding/glow.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
