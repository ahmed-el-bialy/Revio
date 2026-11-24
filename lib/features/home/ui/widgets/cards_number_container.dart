import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import 'home_stat_item.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppCard(
        borderRadius: 22,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: HomeStatItem(
                icon: Icons.style_rounded,
                iconColor: AppColors.primaryCyan,
                label: "Total Cards",
                value: "$totalCards",
              ),
            ),
            const _StatDivider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: HomeStatItem(
                  icon: CupertinoIcons.heart_fill,
                  iconColor: AppColors.favoriteColor,
                  label: "Favorites",
                  value: "$favoriteCards",
                ),
              ),
            ),
            const _StatDivider(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: HomeStatItem(
                  icon: CupertinoIcons.tag_fill,
                  iconColor: AppColors.softAmber,
                  label: "Topics",
                  value: "$categoriesCount",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 38.h,
      color: AppColors.white.withValues(alpha: 0.08),
    );
  }
}
