import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class HomeHeroGreeting extends StatelessWidget {
  const HomeHeroGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back, ready to learn?",
          style: AppStyles.font14White70.copyWith(
            color: AppColors.lavenderGray,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalSpacing(4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Master Your ",
                style: AppStyles.font24BoldIceBlueManrope.copyWith(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
              TextSpan(
                text: "Knowledge",
                style: AppStyles.font24BoldIceBlueManrope.copyWith(
                  fontSize: 25.sp,
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(6),
        Text(
          "Review flashcards and test your memory effortlessly.",
          style: AppStyles.font14White70.copyWith(
            fontSize: 12.5.sp,
            color: AppColors.lavenderGray.withValues(alpha: 0.75),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
