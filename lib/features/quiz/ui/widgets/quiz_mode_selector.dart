import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/quiz/logic/quiz_state.dart';

class QuizModeSelector extends StatelessWidget {
  final void Function(QuizMode mode) onSelectMode;
  final int cardCount;

  const QuizModeSelector({
    super.key,
    required this.onSelectMode,
    required this.cardCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuizModeCard(
          icon: CupertinoIcons.list_bullet_below_rectangle,
          title: "Multiple Choice",
          subtitle: "Pick the right answer from 4 options. Great for quick practice!",
          accentColor: AppColors.primaryTeal,
          badgeLabel: "Recommended",
          onTap: cardCount >= 2 ? () => onSelectMode(QuizMode.multipleChoice) : null,
          isDisabled: cardCount < 2,
          disabledHint: cardCount < 2 ? "Need at least 2 cards" : null,
        ),
        verticalSpacing(16),
        _QuizModeCard(
          icon: CupertinoIcons.keyboard,
          title: "Smart Typing",
          subtitle: "Type your answer freely. Smart matching accepts minor typos.",
          accentColor: AppColors.emeraldGold,
          badgeLabel: "Classic",
          onTap: cardCount >= 1 ? () => onSelectMode(QuizMode.typing) : null,
          isDisabled: cardCount < 1,
          disabledHint: cardCount < 1 ? "No cards available" : null,
        ),
      ],
    );
  }
}

class _QuizModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String badgeLabel;
  final VoidCallback? onTap;
  final bool isDisabled;
  final String? disabledHint;

  const _QuizModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.badgeLabel,
    required this.onTap,
    required this.isDisabled,
    this.disabledHint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isDisabled ? 0.45 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDisabled
                  ? AppColors.gray.withValues(alpha: 0.15)
                  : accentColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: accentColor, size: 26.sp),
                ),
                horizontalSpacing(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(title, style: AppStyles.font16WhiteSemiBold),
                          horizontalSpacing(8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              badgeLabel,
                              style: AppStyles.font11GrayRegular.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpacing(6),
                      Text(subtitle, style: AppStyles.font13GrayMedium),
                      if (disabledHint != null) ...[
                        verticalSpacing(6),
                        Text(
                          disabledHint!,
                          style: AppStyles.font12LavenderGray.copyWith(
                            color: AppColors.errorRed.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isDisabled)
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: accentColor.withValues(alpha: 0.6),
                    size: 16.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
