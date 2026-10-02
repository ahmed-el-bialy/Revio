import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_styles.dart';

class HomeHeroGreeting extends StatelessWidget {
  const HomeHeroGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back! 👋",
          style: AppStyles.font24BoldIceBlueManrope.copyWith(
            fontSize: 26.sp,
            height: 1.2,
          ),
        ),
        verticalSpacing(6),
        Text(
          "Master your decks & test your memory effortlessly.",
          style: AppStyles.font14White70.copyWith(fontSize: 13.5.sp),
        ),
      ],
    );
  }
}
