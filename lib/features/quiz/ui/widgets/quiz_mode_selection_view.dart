import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_mode_selector.dart';

class QuizModeSelectionView extends StatelessWidget {
  final List<CardModel> cards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final void Function(QuizMode mode) onSelectMode;

  const QuizModeSelectionView({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
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
                    _BackChip(onTap: () => context.maybePop()),
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
                            'Quiz',
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
                    padding: EdgeInsets.only(bottom: 28.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroBanner(
                          isLoading: isLoading,
                          cardCount: cards.length,
                        ),
                        verticalSpacing(22),
                        Text(
                          'Choose a mode',
                          style: AppStyles.font18WhiteBold.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        verticalSpacing(12),
                        QuizModeSelector(
                          onSelectMode: onSelectMode,
                          cardCount: isLoading ? 0 : cards.length,
                        ),
                        verticalSpacing(20),
                        const _TipCard(),
                        verticalSpacing(20),
                        if (isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (hasError)
                          _StatusBlock(
                            icon: CupertinoIcons.exclamationmark_circle,
                            title: "Couldn't load cards",
                            subtitle: 'Check your library and try again.',
                            actionLabel: onRetry == null ? null : 'Try again',
                            onAction: onRetry,
                          )
                        else if (cards.isEmpty)
                          _StatusBlock(
                            icon: CupertinoIcons.rectangle_stack_badge_minus,
                            title: 'No cards yet',
                            subtitle: 'Add a few flashcards first, then start a quiz.',
                            actionLabel: 'Add a card',
                            onAction: () => context.pushNamed(
                              AppConstants.newCardScreen,
                            ),
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
    return Material(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.back,
                color: AppColors.primaryCyan,
                size: 18.sp,
              ),
              horizontalSpacing(6),
              Text(
                'Back',
                style: AppStyles.font14White70.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final bool isLoading;
  final int cardCount;

  const _HeroBanner({required this.isLoading, required this.cardCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.primaryCyan.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  CupertinoIcons.sparkles,
                  color: AppColors.primaryCyan,
                  size: 24.sp,
                ),
              ),
              horizontalSpacing(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Knowledge check',
                      style: AppStyles.font18WhiteBold.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    verticalSpacing(4),
                    Text(
                      isLoading
                          ? 'Loading your cards...'
                          : '$cardCount ${cardCount == 1 ? 'flashcard' : 'flashcards'} ready',
                      style: AppStyles.font13GrayMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpacing(14),
          Text(
            'Test recall with typing, or practice recognition with multiple choice.',
            style: AppStyles.font14White70.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.indigoAccent.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.lightbulb_fill,
            color: AppColors.indigoAccent,
            size: 20.sp,
          ),
          horizontalSpacing(12),
          Expanded(
            child: Text(
              'Typing strengthens active recall. Multiple choice is better for a fast review.',
              style: AppStyles.font13GrayMedium.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _StatusBlock({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 44.sp, color: AppColors.gray),
        verticalSpacing(10),
        Text(title, style: AppStyles.font18WhiteBold),
        verticalSpacing(6),
        Text(
          subtitle,
          style: AppStyles.font14White70,
          textAlign: TextAlign.center,
        ),
        if (actionLabel != null && onAction != null) ...[
          verticalSpacing(14),
          AppButton.primary(
            label: actionLabel!,
            onPressed: onAction,
            expanded: false,
          ),
        ],
      ],
    );
  }
}
