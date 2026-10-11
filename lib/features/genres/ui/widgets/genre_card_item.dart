import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_glass_container.dart';

class GenreCardItem extends StatelessWidget {
  final String genre;
  final bool isDefault;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GenreCardItem({
    super.key,
    required this.genre,
    required this.isDefault,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassContainer(
      accentColor: color,
      borderRadius: 20,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          horizontalSpacing(12),
          Expanded(
            child: Text(
              genre,
              style: AppStyles.font18WhiteMedium.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!isDefault) ...[
            IconButton(
              icon: Icon(
                CupertinoIcons.pencil,
                color: AppColors.primaryTeal,
                size: 18.sp,
              ),
              onPressed: onEdit,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(4.w),
            ),
            horizontalSpacing(8),
            IconButton(
              icon: Icon(
                CupertinoIcons.trash,
                color: AppColors.errorRed,
                size: 18.sp,
              ),
              onPressed: onDelete,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(4.w),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                "Default",
                style: AppStyles.font11GrayRegular.copyWith(
                  color: AppColors.lavenderGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
