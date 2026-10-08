import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class CardSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final bool onlyFavorites;
  final VoidCallback onToggleFavorites;
  final ValueChanged<String> onChanged;

  const CardSearchBar({
    super.key,
    required this.searchController,
    required this.onlyFavorites,
    required this.onToggleFavorites,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: AppStyles.font14WhiteSemiBold.copyWith(fontWeight: FontWeight.normal),
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: "Search cards...",
                hintStyle: AppStyles.font14White70,
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: AppColors.lavenderGray,
                  size: 20.sp,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          CupertinoIcons.clear_circled,
                          color: AppColors.lavenderGray,
                          size: 18.sp,
                        ),
                        onPressed: () {
                          searchController.clear();
                          onChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              onlyFavorites
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              color: onlyFavorites ? AppColors.softAmber : AppColors.gray,
            ),
            tooltip: "Favorites Only",
            onPressed: onToggleFavorites,
          ),
        ],
      ),
    );
  }
}
