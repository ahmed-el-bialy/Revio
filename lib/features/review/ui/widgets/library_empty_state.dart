import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class LibraryEmptyState extends StatelessWidget {
  const LibraryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 48.sp,
            color: AppColors.gray,
          ),
          SizedBox(height: 12.h),
          Text(
            "No cards match your filters",
            style: AppStyles.font16LavenderGray,
          ),
        ],
      ),
    );
  }
}
