import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../dashboard/presentation/pages/dashboard_page.dart';
import 'onboarding_screen.dart';
import '../auth/data/repositories/auth_repository_impl.dart';
import '../auth/domain/usecases/verify_token_usecase.dart';
import '../auth/presentation/pages/set_password_page.dart';
import 'presentation/cubit/splash_cubit.dart';
import 'presentation/cubit/splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        VerifyTokenUseCase(AuthRepositoryImpl()),
      )..checkAuth(),
      child: const _SplashScreenContent(),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent();

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent>
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

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        } else if (state is SplashUnauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else if (state is SplashTempPassword) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SetPasswordPage()),
          );
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
