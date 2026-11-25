import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/category_filter_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/data/models/card_model.dart';
import '../../logic/quiz_state.dart';
import 'quiz_favorites_toggle_card.dart';
import 'quiz_mode_card.dart';
import 'quiz_setup_header.dart';
import 'quiz_summary_banner.dart';
import 'quiz_topic_selector_card.dart';

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

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(8),
                  const QuizSetupHeader(),
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
                          QuizTopicSelectorCard(
                            topicDisplayText: topicDisplayText,
                            onTap: () => _openTopicSelectionModal(context),
                          ),
                          verticalSpacing(16),
                          QuizFavoritesToggleCard(
                            onlyFavorites: _onlyFavorites,
                            onChanged: (fav) =>
                                setState(() => _onlyFavorites = fav),
                          ),
                          verticalSpacing(20),
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
                          QuizSummaryBanner(
                            activeSubsetLength: activeSubset.length,
                            isLoading: widget.isLoading,
                            onStartQuiz: () => widget.onStartQuiz(
                              _selectedMode,
                              activeSubset,
                            ),
                          ),
                          if (widget.isLoading) ...[
                            verticalSpacing(20),
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
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
