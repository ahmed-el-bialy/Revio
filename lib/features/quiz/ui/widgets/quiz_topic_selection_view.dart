import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/category_manager.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../cards/data/models/card_model.dart';

class QuizTopicSelectionView extends StatefulWidget {
  final List<CardModel> cards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final void Function(String topic, bool onlyFavorites, List<CardModel> filteredCards) onContinue;

  const QuizTopicSelectionView({
    super.key,
    required this.cards,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    required this.onContinue,
  });

  @override
  State<QuizTopicSelectionView> createState() => _QuizTopicSelectionViewState();
}

class _QuizTopicSelectionViewState extends State<QuizTopicSelectionView> {
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

  void _openTopicSelectionModal(BuildContext context) {
    final core = CategoryManager.getActiveCoreCategories();
    final custom = CategoryManager.getCustomCategories();
    final allCategories = ['All', ...core, ...custom];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Select Quiz Topic",
                    style: AppStyles.font18BoldIndigoAccent.copyWith(
                      color: AppColors.white,
                      fontSize: 18.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, color: AppColors.lavenderGray),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
              verticalSpacing(12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: allCategories.length,
                  separatorBuilder: (context, _) => verticalSpacing(8),
                  itemBuilder: (context, index) {
                    final cat = allCategories[index];
                    final isSelected = cat == _selectedCategory;
                    final catColor = cat == 'All'
                        ? AppColors.primaryTeal
                        : (AppColors.categoryColors[cat] ?? AppColors.primaryTeal);

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => _selectedCategory = cat);
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? catColor.withValues(alpha: 0.2)
                              : AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isSelected ? catColor : AppColors.white.withValues(alpha: 0.08),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: catColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            horizontalSpacing(12),
                            Text(
                              cat,
                              style: AppStyles.font16WhiteSemiBold.copyWith(
                                color: isSelected ? AppColors.white : AppColors.lavenderGray,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.checkmark_alt_circle_fill,
                                color: catColor,
                                size: 20.sp,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                            'Step 1 of 2',
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
                          "Select Quiz Source",
                          style: AppStyles.font24BoldIceBlueManrope.copyWith(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        verticalSpacing(6),
                        Text(
                          "Choose a topic or filter by favorites to customize your quiz.",
                          style: AppStyles.font14White70,
                        ),
                        verticalSpacing(20),
                        // Topic Selector Option Card
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _openTopicSelectionModal(context),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: AppColors.primaryCyan.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryCyan.withValues(alpha: 0.15),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Quiz Topic",
                                        style: AppStyles.font13GrayMedium.copyWith(
                                          color: AppColors.lavenderGray,
                                        ),
                                      ),
                                      verticalSpacing(2),
                                      Text(
                                        _selectedCategory,
                                        style: AppStyles.font16WhiteSemiBold.copyWith(
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
                        verticalSpacing(20),
                        // Favorites Only Toggle Card
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => _onlyFavorites = !_onlyFavorites),
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
                                        ? AppColors.primaryCyan.withValues(alpha: 0.15)
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        verticalSpacing(24),
                        // Summary Banner
                        Container(
                          padding: EdgeInsets.all(18.w),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.primaryCyan.withValues(alpha: 0.2),
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
                                      : "${activeSubset.length} ${activeSubset.length == 1 ? 'card' : 'cards'} available for this filter.",
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
                            label: "Continue to Quiz Modes",
                            icon: CupertinoIcons.arrow_right,
                            onPressed: activeSubset.isEmpty
                                ? null
                                : () => widget.onContinue(
                                      _selectedCategory,
                                      _onlyFavorites,
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
