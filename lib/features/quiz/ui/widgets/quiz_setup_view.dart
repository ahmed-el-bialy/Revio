import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/category_filter_helper.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_back_chip.dart';
import 'quiz_mode_card.dart';

class QuizSetupView extends StatefulWidget {
  final List<CardModel> cards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final void Function(QuizMode mode, List<CardModel> selectedCards) onStartQuiz;

  const QuizSetupView({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    required this.onStartQuiz,
  });

  @override
  State<QuizSetupView> createState() => _QuizSetupViewState();
}

class _QuizSetupViewState extends State<QuizSetupView> {
  Set<String> _selectedCategories = {'All'};
  bool _onlyFavorites = false;
  QuizMode _selectedMode = QuizMode.multipleChoice;

  List<CardModel> get _filteredCards {
    return widget.cards.where((card) {
      final matchesCat =
          _selectedCategories.contains('All') ||
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(card.category ?? 'No Topic') ||
          (_selectedCategories.contains('No Topic') &&
              (card.category == null ||
                  card.category!.isEmpty ||
                  card.category == 'No Topic'));
      final matchesFav = !_onlyFavorites || (card.isFavorite ?? false);
      return matchesCat && matchesFav;
    }).toList();
  }

  void _openTopicSelectionModal(BuildContext context) {
    CategoryFilterHelper.showCategoryFilterModal(
      context: context,
      selectedCategories: _selectedCategories,
      onlyFavorites: _onlyFavorites,
      cards: widget.cards,
      onCategoriesChanged: (cats) {
        setState(() {
          _selectedCategories = cats;
        });
      },
      onFavoritesToggled: (fav) {
        setState(() {
          _onlyFavorites = fav;
        });
      },
      onResetFilters: () {
        setState(() {
          _selectedCategories = {'All'};
          _onlyFavorites = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeSubset = _filteredCards;
    final topicDisplayText =
        _selectedCategories.contains('All') || _selectedCategories.isEmpty
            ? 'All Topics'
            : _selectedCategories.join(', ');

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
                    QuizBackChip(onTap: () => context.maybePop()),
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
                            'Quiz Options',
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
                          "Configure Quiz",
                          style: AppStyles.font24BoldIceBlueManrope.copyWith(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        verticalSpacing(6),
                        Text(
                          "Choose your topics, options, and quiz mode.",
                          style: AppStyles.font14White70,
                        ),
                        verticalSpacing(20),

                        // 1. Topic Selector Option Card
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _openTopicSelectionModal(context),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: AppColors.primaryCyan.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryCyan.withValues(
                                      alpha: 0.15,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.square_stack_3d_up_fill,
                                    color: AppColors.primaryCyan,
                                    size: 18.sp,
                                  ),
                                ),
                                horizontalSpacing(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quiz Topics",
                                        style: AppStyles.font13GrayMedium
                                            .copyWith(
                                              color: AppColors.lavenderGray,
                                            ),
                                      ),
                                      verticalSpacing(2),
                                      Text(
                                        topicDisplayText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppStyles.font16WhiteSemiBold
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_down,
                                  color: AppColors.primaryCyan,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpacing(16),

                        // 2. Favorites Only Toggle Card
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              setState(() => _onlyFavorites = !_onlyFavorites),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: _onlyFavorites
                                    ? AppColors.primaryCyan
                                    : AppColors.white.withValues(alpha: 0.08),
                                width: _onlyFavorites ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: _onlyFavorites
                                        ? AppColors.primaryCyan.withValues(
                                            alpha: 0.15,
                                          )
                                        : AppColors.cardSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _onlyFavorites
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    color: _onlyFavorites
                                        ? AppColors.primaryCyan
                                        : AppColors.lavenderGray,
                                    size: 18.sp,
                                  ),
                                ),
                                horizontalSpacing(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Favorites Only",
                                        style: AppStyles.font16WhiteSemiBold
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      verticalSpacing(2),
                                      Text(
                                        "Test only your starred flashcards",
                                        style: AppStyles.font13GrayMedium
                                            .copyWith(
                                              color: AppColors.lavenderGray,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: _onlyFavorites,
                                  activeTrackColor: AppColors.primaryCyan,
                                  onChanged: (fav) =>
                                      setState(() => _onlyFavorites = fav),
                                ),
                              ],
                            ),
                          ),
                        ),
                        verticalSpacing(20),

                        // 3. Quiz Mode Selector
                        Text(
                          "Quiz Mode",
                          style: AppStyles.font16WhiteSemiBold.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        verticalSpacing(10),
                        Row(
                          children: [
                            Expanded(
                              child: QuizModeCard(
                                title: "Multiple Choice",
                                subtitle: "Pick from 4 options",
                                icon: CupertinoIcons.list_bullet,
                                isSelected:
                                    _selectedMode == QuizMode.multipleChoice,
                                onTap: () => setState(
                                  () => _selectedMode = QuizMode.multipleChoice,
                                ),
                              ),
                            ),
                            horizontalSpacing(12),
                            Expanded(
                              child: QuizModeCard(
                                title: "Smart Typing",
                                subtitle: "Type the answer",
                                icon: CupertinoIcons.keyboard,
                                isSelected: _selectedMode == QuizMode.typing,
                                onTap: () => setState(
                                  () => _selectedMode = QuizMode.typing,
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpacing(24),

                        // Summary Banner
                        Container(
                          padding: EdgeInsets.all(18.w),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.primaryCyan.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.info,
                                color: AppColors.primaryCyan,
                                size: 20.sp,
                              ),
                              horizontalSpacing(12),
                              Expanded(
                                child: Text(
                                  widget.isLoading
                                      ? "Loading cards..."
                                      : "${activeSubset.length} ${activeSubset.length == 1 ? 'card' : 'cards'} ready for this quiz.",
                                  style: AppStyles.font13GrayMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpacing(28),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton.primary(
                            label: "Start Quiz Now",
                            icon: CupertinoIcons.play_fill,
                            onPressed: activeSubset.isEmpty
                                ? null
                                : () => widget.onStartQuiz(
                                    _selectedMode,
                                    activeSubset,
                                  ),
                          ),
                        ),
                        verticalSpacing(20),
                        if (widget.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CircularProgressIndicator(),
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
