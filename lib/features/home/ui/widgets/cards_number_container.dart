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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.indigoAccentTransparent(0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.indigoAccentTransparent(0.25),
            width: 1.w,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.asset(
                "assets/images/container.png",
                height: 56.h,
                fit: BoxFit.contain,
              ),
            ),
            horizontalSpacing(22),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Total Cards",
                    style: AppStyles.font14LavenderGrayMedium,
                  ),
                  verticalSpacing(2),
                  Text(
                    "$totalCards",
                    style: AppStyles.font28BoldIceBlue,
                  ),
                  verticalSpacing(2),
                  Text(
                    "Your learning collection",
                    style: AppStyles.font12LavenderGrayFaded,
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
