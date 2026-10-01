import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardsNumberContainer extends StatelessWidget {
  const CardsNumberContainer({
    super.key,
    required this.totalCards,
    this.favoriteCards = 0,
  });

  final int totalCards;
  final int favoriteCards;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A2540), Color(0xFF0F3460)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withValues(alpha: 0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.style_rounded,
                  iconColor: AppColors.primaryTeal,
                  label: "Total Cards",
                  value: "$totalCards",
                ),
              ),
              Container(
                width: 1,
                height: 48.h,
                color: AppColors.white.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: _StatItem(
                    icon: CupertinoIcons.heart_fill,
                    iconColor: AppColors.softAmber,
                    label: "Starred",
                    value: "$favoriteCards",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            horizontalSpacing(8),
            Text(
              label,
              style: AppStyles.font12LavenderGray.copyWith(
                color: AppColors.white.withValues(alpha: 0.55),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
        verticalSpacing(8),
        Text(
          value,
          style: AppStyles.font28BoldIceBlue.copyWith(
            color: AppColors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
