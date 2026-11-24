// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';

enum GlowVariant { home, quiz, review, addCard }

class AppBackgroundGlow extends StatelessWidget {
  final Widget child;
  final GlowVariant variant;

  const AppBackgroundGlow({
    super.key,
    required this.child,
    this.variant = GlowVariant.home,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Distinct, elegant static ambient background circles for visual depth
          Positioned(
            top: -100.h,
            left: -80.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryCyan.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -90.h,
            right: -80.w,
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.indigoAccent.withValues(alpha: 0.08),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
