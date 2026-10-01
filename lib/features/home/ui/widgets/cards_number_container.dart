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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.indigoAccent.withValues(alpha: 0.9),
              const Color(0xFF4F46E5),
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.style_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      horizontalSpacing(10),
                      Text(
                        "Total Cards",
                        style: AppStyles.font14WhiteSemiBold.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(8),
                  Text(
                    "$totalCards",
                    style: AppStyles.font28BoldIceBlue.copyWith(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 1.w,
              height: 48.h,
              color: Colors.white.withValues(alpha: 0.2),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            color: AppColors.softAmber,
                            size: 18.sp,
                          ),
                        ),
                        horizontalSpacing(10),
                        Text(
                          "Starred",
                          style: AppStyles.font14WhiteSemiBold.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(8),
                    Text(
                      "$favoriteCards",
                      style: AppStyles.font28BoldIceBlue.copyWith(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                      ),
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
