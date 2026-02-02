import 'package:dashboard_grow/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CircularNextButton extends StatefulWidget {
  final double progress;
  final VoidCallback onTap;

  const CircularNextButton({
    super.key,
    required this.progress,
    required this.onTap,
  });

  @override
  State<CircularNextButton> createState() => _CircularNextButtonState();
}

class _CircularNextButtonState extends State<CircularNextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: CircularPercentIndicator(
        radius: 40.w,
        lineWidth: 3,
        percent: widget.progress,
        progressColor: AppColors.brandPrimary,
        backgroundColor: AppColors.neutral100,
        circularStrokeCap: CircularStrokeCap.round,
        center: Container(
          width: 70.w,
          height: 70.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brandPrimary,
          ),
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ),
      ),
    );
  }
}
