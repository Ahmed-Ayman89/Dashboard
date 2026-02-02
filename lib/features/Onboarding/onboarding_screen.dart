import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/helper/app_text_style.dart';
import '../dashboard/presentation/pages/dashboard_page.dart';
import 'onboarding_page_widget.dart';
import 'onboarding_model.dart';
import 'widgets/circal_btn_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  double get progressValue => (_currentPage + 1) / onboardingPages.length;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToOption() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToOption();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingPages.length,
                itemBuilder: (_, index) =>
                    OnboardingPageWidget(page: onboardingPages[index]),
              ),
            ),

            // Indicators
            SmoothPageIndicator(
              controller: _pageController,
              count: onboardingPages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color(0xFF2D6A4F),
                dotColor: Color(0xFFD9D9D9),
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
                spacing: 6,
              ),
            ),

            const SizedBox(height: 48),

            // Bottom Controls (Skip + Circular Button)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button (only if not on the last page)
                  if (_currentPage < onboardingPages.length - 1)
                    TextButton(
                      onPressed: _navigateToOption,
                      child: Text(
                        'Skip',
                        style: AppTextStyle.setPoppinsTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF187259),
                        ).copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),

                  // Circular Progress Button
                  CircularNextButton(
                    progress: progressValue,
                    onTap: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
