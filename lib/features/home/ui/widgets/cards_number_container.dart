import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardsNumberContainer extends StatelessWidget {
  const CardsNumberContainer({super.key, required this.totalCards});

  final int totalCards;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.indigoAccent.withValues(alpha: 0.9),
              const Color(0xFF4F46E5), // Deeper indigo
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.indigoAccent.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.style_rounded,
                color: Colors.white,
                size: 30.sp,
              ),
            ),
            horizontalSpacing(24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Flashcards",
                    style: AppStyles.font14WhiteSemiBold.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  verticalSpacing(4),
                  Text(
                    "$totalCards",
                    style: AppStyles.font28BoldIceBlue.copyWith(
                      color: Colors.white,
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  verticalSpacing(4),
                  Text(
                    "Mastering your library",
                    style: AppStyles.font12LavenderGrayFaded.copyWith(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
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
