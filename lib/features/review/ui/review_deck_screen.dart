import 'package:flip_card/flip_card.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/helpers/category_filter_helper.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/active_filter_banner.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/genre_chip_picker.dart';
import '../../../core/widgets/press_scale_widget.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../../cards/ui/widgets/flash_card.dart';

class ReviewDeckScreen extends StatefulWidget {
  final String? initialCategory;

  const ReviewDeckScreen({super.key, this.initialCategory});

  @override
  State<ReviewDeckScreen> createState() => _ReviewDeckScreenState();
}

class _ReviewDeckScreenState extends State<ReviewDeckScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  bool _onlyFavorites = false;
  final Map<String, GlobalKey<FlipCardState>> _flipKeys = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      if (widget.initialCategory == '__FAVORITES__') {
        _onlyFavorites = true;
      } else {
        _selectedCategory = widget.initialCategory!;
      }
    }
  }

  GlobalKey<FlipCardState> _getFlipKey(String id) {
    return _flipKeys.putIfAbsent(id, () => GlobalKey<FlipCardState>());
  }

  List<CardModel> _filterCards(List<CardModel> allCards) {
    return allCards.where((card) {
      final matchesCat =
          _selectedCategory == 'All' ||
          card.category == _selectedCategory ||
          (_selectedCategory == 'No Topic' &&
              (card.category == null ||
                  card.category!.isEmpty ||
                  card.category == 'No Topic'));
      final matchesFav = !_onlyFavorites || (card.isFavorite ?? false);
      return matchesCat && matchesFav;
    }).toList();
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
          title: Text("Flashcard Deck", style: AppStyles.font18BoldIndigoAccent),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) {
                final hasActiveFilter =
                    _selectedCategory != 'All' || _onlyFavorites;
                return Padding(
                  padding: EdgeInsets.only(right: 4.w),
                  child: PressScale(
                    onTap: () {
                      final cardsState =
                          context.read<GetAllCardsCubit>().state;
                      final cards = cardsState is CardsLoadedSuccess
                          ? cardsState.cards
                          : <CardModel>[];

                      CategoryFilterHelper.showCategoryFilterModal(
                        context: context,
                        selectedCategory: _selectedCategory,
                        onlyFavorites: _onlyFavorites,
                        cards: cards,
                        onCategorySelected: (cat) {
                          setState(() {
                            _selectedCategory = cat;
                            _currentIndex = 0;
                          });
                        },
                        onFavoritesToggled: (fav) {
                          setState(() {
                            _onlyFavorites = fav;
                            _currentIndex = 0;
                          });
                        },
                        onResetFilters: () {
                          setState(() {
                            _selectedCategory = 'All';
                            _onlyFavorites = false;
                            _currentIndex = 0;
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
                            CupertinoIcons.slider_horizontal_3,
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
            IconButton(
              icon: Icon(
                _onlyFavorites
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: _onlyFavorites
                    ? AppColors.softAmber
                    : AppColors.lavenderGray,
              ),
              onPressed: () => setState(() {
                _onlyFavorites = !_onlyFavorites;
                _currentIndex = 0;
              }),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
            builder: (context, state) {
              if (state is CardsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CardsLoadedSuccess) {
                final cards = _filterCards(state.cards);

                if (cards.isEmpty) {
                  return Column(
                    children: [
                      ActiveFilterBanner(
                        selectedCategory: _selectedCategory,
                        onlyFavorites: _onlyFavorites,
                        onClearFilters: () {
                          setState(() {
                            _selectedCategory = 'All';
                            _onlyFavorites = false;
                            _currentIndex = 0;
                          });
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.rectangle_stack_badge_minus,
                                size: 56.sp,
                                color: AppColors.lavenderGray
                                    .withValues(alpha: 0.4),
                              ),
                              verticalSpacing(16),
                              Text(
                                "No cards in this deck",
                                style: AppStyles.font18WhiteBold,
                              ),
                              verticalSpacing(6),
                              Text(
                                "Try switching topics or removing filters.",
                                style: AppStyles.font14White70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (_currentIndex >= cards.length) {
                  _currentIndex = 0;
                }

                final currentCard = cards[_currentIndex];

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 750),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          ActiveFilterBanner(
                            selectedCategory: _selectedCategory,
                            onlyFavorites: _onlyFavorites,
                            onClearFilters: () {
                              setState(() {
                                _selectedCategory = 'All';
                                _onlyFavorites = false;
                                _currentIndex = 0;
                              });
                            },
                          ),
                          GenreChipPicker(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (cat) {
                              setState(() {
                                _selectedCategory = cat;
                                _currentIndex = 0;
                              });
                            },
                          ),
                          verticalSpacing(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryCyan
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  "Card ${_currentIndex + 1} of ${cards.length}",
                                  style: AppStyles.font13GrayMedium.copyWith(
                                    color: AppColors.primaryCyan,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                "Tap card to flip 🔄",
                                style: AppStyles.font12LavenderGrayFaded,
                              ),
                            ],
                          ),
                          verticalSpacing(16),
                          Expanded(
                            child: Center(
                              child: FlashCard(
                                flipKey: _getFlipKey(currentCard.id),
                                cardModel: currentCard,
                                isInQuiz: false,
                              ),
                            ),
                          ),
                          verticalSpacing(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton.secondary(
                                label: "Previous",
                                icon: CupertinoIcons.chevron_left,
                                onPressed: _currentIndex > 0
                                    ? () => setState(() => _currentIndex--)
                                    : null,
                              ),
                              AppButton.primary(
                                label: "Next",
                                icon: CupertinoIcons.chevron_right,
                                onPressed: _currentIndex < cards.length - 1
                                    ? () => setState(() => _currentIndex++)
                                    : null,
                              ),
                            ],
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
