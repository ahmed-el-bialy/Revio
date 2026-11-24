import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';

class GenreCardItem extends StatelessWidget {
  final String genre;
  final int cardCount;
  final bool isDefault;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GenreCardItem({
    super.key,
    required this.genre,
    required this.cardCount,
    required this.isDefault,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 18,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 14.w,
            height: 14.h,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
          horizontalSpacing(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  genre,
                  style: AppStyles.font18WhiteMedium.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                verticalSpacing(3),
                Text(
                  "$cardCount ${cardCount == 1 ? 'card' : 'cards'}",
                  style: AppStyles.font13GrayMedium.copyWith(
                    color: AppColors.lavenderGray,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          if (!isDefault) ...[
            IconButton(
              icon: Icon(
                CupertinoIcons.pencil,
                color: AppColors.primaryCyan,
                size: 18.sp,
              ),
              onPressed: onEdit,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(6.w),
            ),
            horizontalSpacing(6),
            IconButton(
              icon: Icon(
                CupertinoIcons.trash,
                color: AppColors.errorRed,
                size: 18.sp,
              ),
              onPressed: onDelete,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(6.w),
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
