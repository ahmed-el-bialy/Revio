import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/genre_chip_picker.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_mode_selector.dart';

class QuizModeSelectionView extends StatefulWidget {
  final List<CardModel> cards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final void Function(QuizMode mode, List<CardModel> selectedCards) onSelectMode;

  const QuizModeSelectionView({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    required this.onSelectMode,
  });

  @override
  State<QuizModeSelectionView> createState() => _QuizModeSelectionViewState();
}

class _QuizModeSelectionViewState extends State<QuizModeSelectionView> {
  String _selectedCategory = 'All';
  bool _onlyFavorites = false;

  List<CardModel> get _filteredCards {
    return widget.cards.where((card) {
      final matchesCat =
          _selectedCategory == 'All' || card.category == _selectedCategory;
      final matchesFav = !_onlyFavorites || (card.isFavorite ?? false);
      return matchesCat && matchesFav;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeSubset = _filteredCards;

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
                    GestureDetector(
                      onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: _onlyFavorites
                              ? AppColors.primaryCyan.withValues(alpha: 0.2)
                              : AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: _onlyFavorites
                                ? AppColors.primaryCyan
                                : AppColors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _onlyFavorites
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: AppColors.primaryCyan,
                              size: 14.sp,
                            ),
                            horizontalSpacing(6),
                            Text(
                              _onlyFavorites ? "Favorites Only" : "Favorites",
                              style: AppStyles.font13GrayMedium.copyWith(
                                color: AppColors.primaryCyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
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
                        // Topic Source Selector
                        GenreChipPicker(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: (cat) {
                            setState(() => _selectedCategory = cat);
                          },
                          horizontalPadding: 0,
                        ),
                        verticalSpacing(16),
                        // Header Hero Banner
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.surfaceDark,
                                AppColors.cardSurface,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                              color: AppColors.primaryCyan.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryCyan
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Icon(
                                  CupertinoIcons.sparkles,
                                  color: AppColors.primaryCyan,
                                  size: 24.sp,
                                ),
                              ),
                              horizontalSpacing(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Quiz Arena",
                                      style: AppStyles.font18WhiteBold.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    verticalSpacing(4),
                                    Text(
                                      widget.isLoading
                                          ? "Loading cards..."
                                          : "${activeSubset.length} ${activeSubset.length == 1 ? 'card' : 'cards'} ready for quiz",
                                      style: AppStyles.font13GrayMedium.copyWith(
                                        color: AppColors.lavenderGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpacing(24),
                        Text(
                          "Select Quiz Mode",
                          style: AppStyles.font18WhiteBold.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        verticalSpacing(14),
                        QuizModeSelector(
                          onSelectMode: (mode) =>
                              widget.onSelectMode(mode, activeSubset),
                          cardCount: widget.isLoading ? 0 : activeSubset.length,
                        ),
                        verticalSpacing(24),
                        if (widget.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (widget.hasError)
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
                                if (widget.onRetry != null)
                                  AppButton.secondary(
                                    label: "Try again",
                                    onPressed: widget.onRetry!,
                                  ),
                              ],
                            ),
                          )
                        else if (activeSubset.isEmpty)
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
                                  "No cards match filter!",
                                  style: AppStyles.font18WhiteBold,
                                ),
                                verticalSpacing(4),
                                Text(
                                  "Switch topics or add cards to start.",
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
              "Back",
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
