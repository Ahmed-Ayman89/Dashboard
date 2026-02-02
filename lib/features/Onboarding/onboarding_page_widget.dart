import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/helper/app_text_style.dart';
import 'onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          page.illustrationPath.endsWith('.svg')
              ? SvgPicture.asset(
                  page.illustrationPath,
                  height: 280.h,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  page.illustrationPath,
                  height: 280.h,
                  fit: BoxFit.contain,
                ),
          SizedBox(height: 48.h),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.onboardingTitle,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              page.description,
              textAlign: TextAlign.center,
              style: AppTextStyle.onboardingDescription,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
