import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/helpers/category_filter_helper.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/active_filter_banner.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/press_scale_widget.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import 'widgets/study_empty_state.dart';
import 'widgets/study_flash_card.dart';
import 'widgets/study_navigation_row.dart';
import 'widgets/study_progress_row.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _currentIndex = 0;
  Set<String> _selectedCategories = {'All'};
  bool _onlyFavorites = false;
  final Map<String, GlobalKey<FlipCardState>> _flipKeys = {};

  GlobalKey<FlipCardState> _getFlipKey(String id) {
    return _flipKeys.putIfAbsent(id, () => GlobalKey<FlipCardState>());
  }

  List<CardModel> _filterCards(List<CardModel> allCards) {
    return allCards.where((card) {
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

  void _shuffle(List<CardModel> allFiltered) {
    setState(() {
      _currentIndex = 0;
      _flipKeys.clear();
    });
  }

  void _resetFlipKey(String id) {
    _flipKeys.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.review,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.chevron_left,
              color: AppColors.primaryCyan,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text('Study Mode', style: AppStyles.font18BoldIndigoAccent),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) {
                final hasActiveFilter =
                    (!_selectedCategories.contains('All') &&
                            _selectedCategories.isNotEmpty) ||
                        _onlyFavorites;
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: PressScale(
                    onTap: () {
                      final cardsState =
                          context.read<GetAllCardsCubit>().state;
                      final cards = cardsState is CardsLoadedSuccess
                          ? cardsState.cards
                          : <CardModel>[];

                      CategoryFilterHelper.showCategoryFilterModal(
                        context: context,
                        selectedCategories: _selectedCategories,
                        onlyFavorites: _onlyFavorites,
                        cards: cards,
                        onCategoriesChanged: (cats) {
                          setState(() {
                            _selectedCategories = cats;
                            _currentIndex = 0;
                            _flipKeys.clear();
                          });
                        },
                        onFavoritesToggled: (fav) {
                          setState(() {
                            _onlyFavorites = fav;
                            _currentIndex = 0;
                            _flipKeys.clear();
                          });
                        },
                        onResetFilters: () {
                          setState(() {
                            _selectedCategories = {'All'};
                            _onlyFavorites = false;
                            _currentIndex = 0;
                            _flipKeys.clear();
                          });
                        },
                      );
                    },
                    scaleDown: 0.90,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasActiveFilter
                                ? AppColors.primaryCyan.withValues(alpha: 0.18)
                                : Colors.transparent,
                            border: Border.all(
                              color: hasActiveFilter
                                  ? AppColors.primaryCyan.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.line_horizontal_3_decrease,
                            color: hasActiveFilter
                                ? AppColors.primaryCyan
                                : AppColors.lavenderGray,
                            size: 20.sp,
                          ),
                        ),
                        if (hasActiveFilter)
                          Positioned(
                            top: 2.h,
                            right: 2.w,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.primaryCyan,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.darkBackground,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
            builder: (context, state) {
              if (state is CardsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryCyan,
                  ),
                );
              }

              if (state is CardsLoadedSuccess) {
                final allFiltered = _filterCards(state.cards);

                if (allFiltered.isEmpty) {
                  return Column(
                    children: [
                      ActiveFilterBanner(
                        selectedCategories: _selectedCategories,
                        onlyFavorites: _onlyFavorites,
                        onClearFilters: () {
                          setState(() {
                            _selectedCategories = {'All'};
                            _onlyFavorites = false;
                            _currentIndex = 0;
                            _flipKeys.clear();
                          });
                        },
                      ),
                      Expanded(
                        child: StudyEmptyState(onlyFavorites: _onlyFavorites),
                      ),
                    ],
                  );
                }

                if (_currentIndex >= allFiltered.length) {
                  _currentIndex = 0;
                }

                final currentCard = allFiltered[_currentIndex];
                final progress = (_currentIndex + 1) / allFiltered.length;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 750),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          ActiveFilterBanner(
                            selectedCategories: _selectedCategories,
                            onlyFavorites: _onlyFavorites,
                            onClearFilters: () {
                              setState(() {
                                _selectedCategories = {'All'};
                                _onlyFavorites = false;
                                _currentIndex = 0;
                                _flipKeys.clear();
                              });
                            },
                          ),
                          verticalSpacing(10),
                          StudyProgressRow(
                            current: _currentIndex + 1,
                            total: allFiltered.length,
                            progress: progress,
                            onShuffle: () {
                              _shuffle(allFiltered);
                              context
                                  .read<GetAllCardsCubit>()
                                  .fetchAllCards();
                            },
                          ),
                          verticalSpacing(16),
                          Expanded(
                            child: Center(
                              child: GestureDetector(
                                onHorizontalDragEnd: (details) {
                                  if (details.primaryVelocity! < 0) {
                                    if (_currentIndex < allFiltered.length - 1) {
                                      _resetFlipKey(currentCard.id);
                                      setState(() => _currentIndex++);
                                    }
                                  } else if (details.primaryVelocity! > 0) {
                                    if (_currentIndex > 0) {
                                      _resetFlipKey(currentCard.id);
                                      setState(() => _currentIndex--);
                                    }
                                  }
                                },
                                child: StudyFlashCard(
                                  key: ValueKey(currentCard.id),
                                  card: currentCard,
                                  flipKey: _getFlipKey(currentCard.id),
                                ),
                              ),
                            ),
                          ),
                          verticalSpacing(20),
                          StudyNavigationRow(
                            onPrev: _currentIndex > 0
                                ? () {
                                    _resetFlipKey(currentCard.id);
                                    setState(() => _currentIndex--);
                                  }
                                : null,
                            onNext: _currentIndex < allFiltered.length - 1
                                ? () {
                                    _resetFlipKey(currentCard.id);
                                    setState(() => _currentIndex++);
                                  }
                                : null,
                            isLast:
                                _currentIndex == allFiltered.length - 1,
                          ),
                          verticalSpacing(24),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
