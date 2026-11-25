import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/category_filter_helper.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/active_filter_banner.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../logic/delete_card/delete_card_cubit.dart';
import '../logic/delete_card/delete_card_state.dart';
import '../logic/edit_card/edit_card_cubit.dart';
import '../logic/edit_card/edit_card_state.dart';
import 'widgets/add_card_modal_bottom_sheet.dart';
import 'widgets/card_search_bar.dart';
import 'widgets/library_cards_list.dart';

class ReviewCardsScreen extends StatefulWidget {
  final String? initialCategory;

  const ReviewCardsScreen({super.key, this.initialCategory});

  @override
  State<ReviewCardsScreen> createState() => _ReviewCardsScreenState();
}

class _ReviewCardsScreenState extends State<ReviewCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Set<String> _selectedCategories;
  bool _onlyFavorites = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory == '__FAVORITES__') {
      _selectedCategories = {'All'};
      _onlyFavorites = true;
    } else if (widget.initialCategory != null &&
        widget.initialCategory!.isNotEmpty) {
      _selectedCategories = {widget.initialCategory!};
    } else {
      _selectedCategories = {'All'};
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CardModel> _filterCards(List<CardModel> cards) {
    return cards.where((card) {
      final matchesSearch =
          _searchController.text.trim().isEmpty ||
          card.front.toLowerCase().contains(
            _searchController.text.trim().toLowerCase(),
          ) ||
          card.back.toLowerCase().contains(
            _searchController.text.trim().toLowerCase(),
          ) ||
          (card.hint?.toLowerCase().contains(
                _searchController.text.trim().toLowerCase(),
              ) ??
              false);

      final matchesCategory =
          _selectedCategories.contains('All') ||
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(card.category ?? 'No Topic') ||
          (_selectedCategories.contains('No Topic') &&
              (card.category == null ||
                  card.category!.isEmpty ||
                  card.category == 'No Topic'));

      final matchesFavorites = !_onlyFavorites || (card.isFavorite ?? false);

      return matchesSearch && matchesCategory && matchesFavorites;
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
          title: Text(
            "Manage Library",
            style: AppStyles.font18BoldIndigoAccent,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.indigoAccent),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.add_circled_solid,
                color: AppColors.primaryTeal,
                size: 24.sp,
              ),
              onPressed: () {
                AppSheet.show(
                  context,
                  builder: (_) => AddCardModalBottomSheet(
                    initialCategory: _selectedCategories.contains('All')
                        ? 'General'
                        : _selectedCategories.first,
                  ),
                );
              },
            ),
            horizontalSpacing(8),
          ],
        ),
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<DeleteCardCubit, DeleteCardState>(
                listener: (context, state) {
                  if (state is DeleteCardSuccess) {
                    SnackBarHelper.showSuccess(
                      context,
                      "Card deleted successfully",
                    );
                  } else if (state is DeleteCardError) {
                    SnackBarHelper.showError(context, state.error);
                  }
                },
              ),
              BlocListener<EditCardCubit, EditCardState>(
                listener: (context, state) {
                  if (state is EditCardSuccess) {
                    SnackBarHelper.showSuccess(
                      context,
                      "Card updated successfully",
                    );
                  } else if (state is EditCardError) {
                    SnackBarHelper.showError(context, state.error);
                  }
                },
              ),
            ],
            child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              builder: (context, state) {
                if (state is CardsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.indigoAccent,
                    ),
                  );
                }

                if (state is CardsLoadedSuccess) {
                  final filteredCards = _filterCards(state.cards);
                  final hasActiveFilter =
                      (!_selectedCategories.contains('All') &&
                              _selectedCategories.isNotEmpty) ||
                          _onlyFavorites;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 850),
                          child: Column(
                            children: [
                              CardSearchBar(
                                searchController: _searchController,
                                hasActiveFilter: hasActiveFilter,
                                onOpenFilter: () {
                                  CategoryFilterHelper.showCategoryFilterModal(
                                    context: context,
                                    selectedCategories: _selectedCategories,
                                    onlyFavorites: _onlyFavorites,
                                    cards: state.cards,
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
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                              ActiveFilterBanner(
                                selectedCategories: _selectedCategories,
                                onlyFavorites: _onlyFavorites,
                                onClearFilters: () {
                                  setState(() {
                                    _selectedCategories = {'All'};
                                    _onlyFavorites = false;
                                  });
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 8.h,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Showing: ${filteredCards.length} ${filteredCards.length == 1 ? 'card' : 'cards'} / ${state.cards.length} ${state.cards.length == 1 ? 'card' : 'cards'}",
                                      style: AppStyles.font14White70,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Tap a card to edit",
                                      style: AppStyles.font12LavenderGrayFaded,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: LibraryCardsList(
                                  filteredCards: filteredCards,
                                  hasCardsOverall: state.cards.isNotEmpty,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is CardsError) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: AppStyles.font16LavenderGray.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
