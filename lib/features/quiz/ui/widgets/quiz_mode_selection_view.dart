import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_mode_selector.dart';

class QuizModeSelectionView extends StatelessWidget {
  final List<CardModel> cards;
  final Function(QuizMode mode) onSelectMode;

  const QuizModeSelectionView({
    super.key,
    required this.cards,
    required this.onSelectMode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: Icon(
                    CupertinoIcons.back,
                    color: AppColors.lavenderGray,
                    size: 22.sp,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                horizontalSpacing(8),
                Text("Quiz Mode", style: AppStyles.font18BoldIndigoAccent),
              ],
            ),
            verticalSpacing(20),
            Text(
              "Choose how you\nwant to be tested",
              style: AppStyles.font24BoldIceBlueManrope.copyWith(
                fontSize: 25.sp,
                height: 1.25,
              ),
            ),
            verticalSpacing(6),
            Text(
              "${cards.length} cards ready · Pick your challenge",
              style: AppStyles.font14White70,
            ),
            verticalSpacing(24),
            QuizModeSelector(
              onSelectMode: onSelectMode,
              cardCount: cards.length,
            ),
            verticalSpacing(24),
            if (cards.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.rectangle_stack_badge_minus,
                      size: 48.sp,
                      color: AppColors.gray,
                    ),
                    verticalSpacing(10),
                    Text("No cards yet!", style: AppStyles.font18WhiteBold),
                    verticalSpacing(4),
                    Text(
                      "Add cards first to start a quiz.",
                      style: AppStyles.font14White70,
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
