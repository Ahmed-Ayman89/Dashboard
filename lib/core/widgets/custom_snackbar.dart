import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../helper/app_text_style.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    required SnackBarType type,
    super.duration = const Duration(seconds: 3),
  }) : super(
          content: CustomSnackBarContent(message: message, type: type),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        );
}

class CustomSnackBarContent extends StatelessWidget {
  final String message;
  final SnackBarType type;

  const CustomSnackBarContent({
    required this.message,
    required this.type,
  });

  Color _getColor() {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF187259);
      case SnackBarType.error:
        return const Color(0xFFDC2626);
      case SnackBarType.warning:
        return const Color(0xFFF59E0B);
      case SnackBarType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData _getIcon() {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.error:
        return Icons.error;
      case SnackBarType.warning:
        return Icons.warning;
      case SnackBarType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: color, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: AppTextStyle.bodyRegular.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            _getIcon(),
            color: color,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}
