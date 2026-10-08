import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class LibraryEmptyState extends StatelessWidget {
  final bool hasCardsOverall;

  const LibraryEmptyState({
    super.key,
    this.hasCardsOverall = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasCardsOverall
                  ? CupertinoIcons.search
                  : CupertinoIcons.square_stack_3d_up,
              size: 52.sp,
              color: AppColors.primaryTeal.withValues(alpha: 0.8),
            ),
            SizedBox(height: 16.h),
            Text(
              hasCardsOverall ? "No cards match your filters" : "No cards yet",
              style: AppStyles.font18WhiteBold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              hasCardsOverall
                  ? "Try searching for a different keyword or clear your active filters."
                  : "Create your first flashcard by tapping the '+' button at the top right!",
              style: AppStyles.font14White70,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
