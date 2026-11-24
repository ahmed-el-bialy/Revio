import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../logic/quiz_state.dart';

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
          title: 'Multiple Choice',
          subtitle:
              'Pick the right answer from unique options. Fast recognition practice.',
          accentColor: AppColors.primaryCyan,
          badgeLabel: 'Quick',
          onTap: cardCount >= 2
              ? () => onSelectMode(QuizMode.multipleChoice)
              : null,
          isDisabled: cardCount < 2,
          disabledHint: cardCount < 2 ? 'Need at least 2 cards' : null,
        ),
        verticalSpacing(14),
        _QuizModeCard(
          icon: CupertinoIcons.keyboard,
          title: 'Smart Typing',
          subtitle:
              'Type the answer. Typos, short forms, and alternatives like USA / United States are accepted.',
          accentColor: AppColors.indigoAccent,
          badgeLabel: 'Recall',
          onTap: cardCount >= 1 ? () => onSelectMode(QuizMode.typing) : null,
          isDisabled: cardCount < 1,
          disabledHint: cardCount < 1 ? 'No cards available' : null,
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
    return Opacity(
      opacity: isDisabled ? 0.55 : 1,
      child: AppCard(
        onTap: isDisabled ? null : onTap,
        borderRadius: 22,
        borderColor: isDisabled
            ? AppColors.gray.withValues(alpha: 0.15)
            : accentColor.withValues(alpha: 0.35),
        padding: EdgeInsets.all(18.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              ),
              child: Icon(icon, color: accentColor, size: 24.sp),
            ),
            horizontalSpacing(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      Text(
                        title,
                        style: AppStyles.font16WhiteSemiBold.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          badgeLabel,
                          style: AppStyles.font11GrayRegular.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(6),
                  Text(
                    subtitle,
                    style: AppStyles.font13GrayMedium.copyWith(height: 1.4),
                  ),
                  if (disabledHint != null) ...[
                    verticalSpacing(8),
                    Text(
                      disabledHint!,
                      style: AppStyles.font12LavenderGray.copyWith(
                        color: AppColors.errorRed.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isDisabled) ...[
              horizontalSpacing(8),
              Icon(
                CupertinoIcons.chevron_right,
                color: accentColor,
                size: 16.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
