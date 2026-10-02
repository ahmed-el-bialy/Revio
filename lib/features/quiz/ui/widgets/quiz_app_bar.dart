import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../logic/quiz_cubit.dart';
import '../../logic/quiz_state.dart';

class QuizAppBar extends StatelessWidget {
  final QuizInProgress state;

  const QuizAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () =>
                  context.read<QuizCubit>().emitShowModeSelection(),
              icon: Icon(
                CupertinoIcons.back,
                color: AppColors.lavenderGray,
                size: 22.sp,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            horizontalSpacing(6),
            Expanded(
              child: Text(
                state.quizMode == QuizMode.multipleChoice
                    ? "Multiple Choice"
                    : "Smart Typing",
                style: AppStyles.font18BoldIndigoAccent,
              ),
            ),
            _buildModeInfoButton(context, state.quizMode),
            horizontalSpacing(8),
            _buildShuffleBadge(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildModeInfoButton(BuildContext context, QuizMode mode) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              children: [
                Icon(
                  mode == QuizMode.multipleChoice
                      ? CupertinoIcons.list_bullet
                      : CupertinoIcons.keyboard,
                  color: AppColors.primaryTeal,
                  size: 22.sp,
                ),
                horizontalSpacing(10),
                Text(
                  mode == QuizMode.multipleChoice
                      ? "Multiple Choice"
                      : "Smart Typing",
                  style: AppStyles.font16WhiteSemiBold,
                ),
              ],
            ),
            content: Text(
              mode == QuizMode.multipleChoice
                  ? "Tap the correct answer from 4 options. One attempt per card — choose wisely!"
                  : "Type your answer. Minor typos and short forms are accepted. You have one attempt per card.",
              style: AppStyles.font14White70,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Got it!",
                  style: AppStyles.font15IndigoAccentSemiBold,
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.primaryTeal.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primaryTeal.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.info_circle,
              color: AppColors.primaryTeal,
              size: 14.sp,
            ),
            horizontalSpacing(4),
            Text(
              mode == QuizMode.multipleChoice ? "MCQ Mode" : "Typing Mode",
              style: AppStyles.font11GrayRegular.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShuffleBadge(BuildContext context, QuizInProgress state) {
    return GestureDetector(
      onTap: () => context.read<QuizCubit>().emitToggleShuffle(),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: state.isShuffled
              ? AppColors.emeraldGold.withValues(alpha: 0.15)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: state.isShuffled
                ? AppColors.emeraldGold.withValues(alpha: 0.4)
                : AppColors.gray.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(
          CupertinoIcons.shuffle,
          color: state.isShuffled ? AppColors.emeraldGold : AppColors.gray,
          size: 16.sp,
        ),
      ),
    );
  }
}
