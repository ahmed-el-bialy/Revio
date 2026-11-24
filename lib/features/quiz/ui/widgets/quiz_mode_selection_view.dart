import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_mode_selector.dart';

class QuizModeSelectionView extends StatelessWidget {
  final List<CardModel> cards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final Function(QuizMode mode) onSelectMode;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: true,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(6),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => context.maybePop(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: 6.w,
                            top: 4.h,
                            bottom: 4.h,
                          ),
                          child: Icon(
                            CupertinoIcons.back,
                            color: AppColors.lavenderGray,
                            size: 22.sp,
                          ),
                        ),
                      ),
                      horizontalSpacing(4),
                      Text(
                        "Quiz Mode",
                        style: AppStyles.font18BoldIndigoAccent.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 12.h,
                        bottom: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose how you\nwant to be tested",
                            style: AppStyles.font24BoldIceBlueManrope.copyWith(
                              fontSize: 26.sp,
                              height: 1.25,
                            ),
                          ),
                          verticalSpacing(8),
                          Text(
                            isLoading
                                ? "Loading your cards..."
                                : "${cards.length} cards ready · Pick your challenge",
                            style: AppStyles.font14White70,
                          ),
                          verticalSpacing(24),
                          QuizModeSelector(
                            onSelectMode: onSelectMode,
                            cardCount: isLoading ? 0 : cards.length,
                          ),
                          verticalSpacing(24),
                          if (isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (hasError)
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    CupertinoIcons.exclamationmark_circle,
                                    size: 44.sp,
                                    color: AppColors.gray,
                                  ),
                                  verticalSpacing(10),
                                  Text(
                                    "Couldn't load cards",
                                    style: AppStyles.font18WhiteBold,
                                  ),
                                  verticalSpacing(8),
                                  if (onRetry != null)
                                    TextButton(
                                      onPressed: onRetry,
                                      child: const Text("Try again"),
                                    ),
                                ],
                              ),
                            )
                          else if (cards.isEmpty)
                              Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.rectangle_stack_badge_minus,
                                      size: 48.sp,
                                      color: AppColors.gray,
                                    ),
                                    verticalSpacing(10),
                                    Text(
                                      "No cards yet!",
                                      style: AppStyles.font18WhiteBold,
                                    ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}