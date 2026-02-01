import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text styles using Poppins font for the English application
class AppTextStyle {
  // Prevent instantiation
  AppTextStyle._();

  /// Custom text style with Poppins font
  static TextStyle setPoppinsTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// White text with Poppins font
  static TextStyle setPoppinsWhite({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.white,
    );
  }

  /// Primary text (dark) with Poppins font
  static TextStyle setPoppinsPrimaryText({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.textPrimary,
    );
  }

  /// Secondary text (gray) with Poppins font
  static TextStyle setPoppinsSecondaryText({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.textSecondary,
    );
  }

  /// Light gray text with Poppins font
  static TextStyle setPoppinsLightGray({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.lightGray,
    );
  }

  /// Dark gray text with Poppins font
  static TextStyle setPoppinsDarkGray({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.darkGray,
    );
  }

  /// Black text with Poppins font
  static TextStyle setPoppinsBlack({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.black,
    );
  }

  /// Brand primary color text with Poppins font
  static TextStyle setPoppinsBrandPrimary({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.brandPrimary,
    );
  }

  /// Brand secondary color text with Poppins font
  static TextStyle setPoppinsBrandSecondary({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.brandSecondary,
    );
  }

  /// Error text with Poppins font
  static TextStyle setPoppinsError({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.error,
    );
  }

  /// Success text with Poppins font
  static TextStyle setPoppinsSuccess({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.success,
    );
  }

  /// Warning text with Poppins font
  static TextStyle setPoppinsWarning({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.warning,
    );
  }

  // ============================================================================
  // CAIRO FONT STYLES (Arabic support)
  // ============================================================================

  /// Custom text style with Cairo font
  static TextStyle setCairoTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// White text with Cairo font
  static TextStyle setCairoWhite({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.white,
    );
  }

  /// Black text with Cairo font
  static TextStyle setCairoBlack({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: AppColors.black,
    );
  }

  // ============================================================================
  // ONBOARDING SPECIFIC STYLES
  // ============================================================================

  /// Onboarding title - Inter 20px, weight 590 (SemiBold), height 22px
  static TextStyle get onboardingTitle => GoogleFonts.inter(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 22 / 20,
  );

  /// Onboarding description - Inter 16px, weight 400 (Regular), height 22px
  static TextStyle get onboardingDescription => GoogleFonts.inter(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 22 / 16,
  );

  // ============================================================================
  // PREDEFINED COMMON STYLES
  // ============================================================================

  /// Heading 1 - Large bold text
  static TextStyle get heading1 => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Heading 2 - Medium bold text
  static TextStyle get heading2 => GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// Heading 3 - Small bold text
  static TextStyle get heading3 => GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Body text - Regular
  static TextStyle get bodyRegular => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  /// Body text - Medium
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Body text - Small
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Caption text
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  /// Button text
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
}
