import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_mode_selector.dart';

class QuizModeSelectionView extends StatelessWidget {
  final List<CardModel> cards;
  final VoidCallback onBackToTopics;
  final void Function(QuizMode mode) onSelectMode;

  const QuizModeSelectionView({
    super.key,
    required this.cards,
    required this.onBackToTopics,
    required this.onSelectMode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(8),
                Row(
                  children: [
                    _BackChip(onTap: onBackToTopics),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.primaryCyan.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.bolt_fill,
                            color: AppColors.primaryCyan,
                            size: 14.sp,
                          ),
                          horizontalSpacing(6),
                          Text(
                            'Step 2 of 2',
                            style: AppStyles.font13GrayMedium.copyWith(
                              color: AppColors.primaryCyan,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpacing(18),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Quiz Mode",
                          style: AppStyles.font24BoldIceBlueManrope.copyWith(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        verticalSpacing(6),
                        Text(
                          "${cards.length} ${cards.length == 1 ? 'card' : 'cards'} selected for this quiz session.",
                          style: AppStyles.font14White70,
                        ),
                        verticalSpacing(24),
                        QuizModeSelector(
                          onSelectMode: onSelectMode,
                          cardCount: cards.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackChip extends StatelessWidget {
  final VoidCallback onTap;

  const _BackChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.back,
              color: AppColors.primaryCyan,
              size: 18.sp,
            ),
            horizontalSpacing(6),
            Text(
              "Topics",
              style: AppStyles.font14White70.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
