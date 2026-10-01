import 'package:code_alpha_flash_card_app/core/constants/app_constants.dart';
import 'package:code_alpha_flash_card_app/core/helpers/snackbar_helper.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/cards/data/models/card_model.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:code_alpha_flash_card_app/features/cards/ui/widgets/flash_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../logic/delete_card/delete_card_cubit.dart';
import '../logic/delete_card/delete_card_state.dart';
import '../logic/edit_card/edit_card_cubit.dart';
import '../logic/edit_card/edit_card_state.dart';

class ReviewCardsScreen extends StatefulWidget {
  const ReviewCardsScreen({super.key});

  @override
  State<ReviewCardsScreen> createState() => _ReviewCardsScreenState();
}

class _ReviewCardsScreenState extends State<ReviewCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  bool _onlyFavorites = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CardModel> _filterCards(List<CardModel> cards) {
    return cards.where((card) {
      final matchesSearch = _searchController.text.trim().isEmpty ||
          card.front.toLowerCase().contains(_searchController.text.trim().toLowerCase()) ||
          card.back.toLowerCase().contains(_searchController.text.trim().toLowerCase()) ||
          (card.hint?.toLowerCase().contains(_searchController.text.trim().toLowerCase()) ?? false);

      final matchesCategory = _selectedCategory == 'All' || card.category == _selectedCategory;

      final matchesFavorites = !_onlyFavorites || (card.isFavorite ?? false);

      return matchesSearch && matchesCategory && matchesFavorites;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allCategories = ['All', ...AppConstants.categories];

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
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
      ),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<DeleteCardCubit, DeleteCardState>(
              listener: (context, state) {
                if (state is DeleteCardSuccess) {
                  SnackBarHelper.showSuccess(
                      context, "Card deleted successfully");
                } else if (state is DeleteCardError) {
                  SnackBarHelper.showError(context, state.error);
                }
              },
            ),
            BlocListener<EditCardCubit, EditCardState>(
              listener: (context, state) {
                if (state is EditCardSuccess) {
                  SnackBarHelper.showSuccess(
                      context, "Card updated successfully");
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

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: "Search cards...",
                                hintStyle: AppStyles.font14White70,
                                prefixIcon: Icon(CupertinoIcons.search,
                                    color: AppColors.lavenderGray, size: 20.sp),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(CupertinoIcons.clear_circled,
                                            color: AppColors.lavenderGray, size: 18.sp),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {});
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 10.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon: Icon(
                              _onlyFavorites ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: _onlyFavorites ? AppColors.softAmber : AppColors.gray,
                            ),
                            tooltip: "Favorites Only",
                            onPressed: () {
                              setState(() {
                                _onlyFavorites = !_onlyFavorites;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 36.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: allCategories.length,
                        separatorBuilder: (context, index) => SizedBox(width: 6.w),
                        itemBuilder: (context, index) {
                          final cat = allCategories[index];
                          final isSelected = cat == _selectedCategory;
                          final catColor = cat == 'All'
                              ? AppColors.indigoAccent
                              : (AppColors.categoryColors[cat] ?? AppColors.indigoAccent);

                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: catColor.withValues(alpha: 0.25),
                            backgroundColor: AppColors.oceanBlue.withValues(alpha: 0.4),
                            side: BorderSide(
                              color: isSelected ? catColor : AppColors.gray.withValues(alpha: 0.2),
                            ),
                            labelStyle: AppStyles.font14White70.copyWith(
                              color: isSelected ? catColor : AppColors.lavenderGray,
                              fontSize: 12.sp,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                              }
                            },
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: Row(
                        children: [
                          Text(
                            "Showing: ${filteredCards.length} / ${state.cards.length} cards",
                            style: AppStyles.font14White70,
                          ),
                          const Spacer(),
                          Text(
                            "Tap card to flip",
                            style: AppStyles.font12LavenderGrayFaded,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: filteredCards.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.search,
                                      size: 48.sp, color: AppColors.gray),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "No cards match your filters",
                                    style: AppStyles.font16LavenderGray,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
                              itemCount: filteredCards.length,
                              itemBuilder: (context, index) {
                                final cardModel = filteredCards[index];

                                return Dismissible(
                                  key: Key(cardModel.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.errorRed.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(color: AppColors.errorRed),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 24.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Delete",
                                          style: AppStyles.font14WhiteSemiBold
                                              .copyWith(color: AppColors.errorRed),
                                        ),
                                        SizedBox(width: 8.w),
                                        Icon(CupertinoIcons.trash,
                                            color: AppColors.errorRed, size: 22.sp),
                                      ],
                                    ),
                                  ),
                                  onDismissed: (_) {
                                    context
                                        .read<DeleteCardCubit>()
                                        .emitDeleteCard(cardModel.id);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    child: FlashCard(cardModel: cardModel, isInQuiz: false),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
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
    );
  }
}
