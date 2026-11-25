import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class StudyEmptyState extends StatelessWidget {
  final bool onlyFavorites;

  const StudyEmptyState({super.key, required this.onlyFavorites});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              onlyFavorites
                  ? CupertinoIcons.heart_slash
                  : CupertinoIcons.rectangle_stack_badge_minus,
              size: 64.sp,
              color: AppColors.lavenderGray.withValues(alpha: 0.3),
            ),
            verticalSpacing(20),
            Text(
              onlyFavorites ? 'No Favorite Cards' : 'No Cards Yet',
              style: AppStyles.font18WhiteBold,
              textAlign: TextAlign.center,
            ),
            verticalSpacing(8),
            Text(
              onlyFavorites
                  ? 'Mark some cards as favorites to study them here.'
                  : 'Add flashcards to start studying.',
              style: AppStyles.font14White70,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
