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
    this.categoriesCount = 0,
  });

  final int totalCards;
  final int favoriteCards;
  final int categoriesCount;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cardSurface,
                AppColors.surfaceDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.18),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withValues(alpha: 0.06),
                blurRadius: 24,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.style_rounded,
                      iconColor: AppColors.primaryTeal,
                      label: "Total Cards",
                      value: "$totalCards",
                    ),
                  ),
                  _buildDivider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: _StatItem(
                        icon: CupertinoIcons.heart_fill,
                        iconColor: AppColors.favoriteColor,
                        label: "Favorites",
                        value: "$favoriteCards",
                      ),
                    ),
                  ),
                  _buildDivider(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.w),
                      child: _StatItem(
                        icon: CupertinoIcons.grid,
                        iconColor: AppColors.softAmber,
                        label: "Topics",
                        value: "$categoriesCount",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 42.h,
      color: AppColors.white.withValues(alpha: 0.08),
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
              padding: EdgeInsets.all(5.w),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 15.sp),
            ),
            horizontalSpacing(6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.font12LavenderGray.copyWith(
                  color: AppColors.white.withValues(alpha: 0.6),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(6),
        Text(
          value,
          style: AppStyles.font28BoldIceBlue.copyWith(
            color: AppColors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
