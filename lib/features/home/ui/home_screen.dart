import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/cards_number_container.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/home_option_tile.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../cards/data/models/card_model.dart';
import '../models/navigation_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryFilter = "All";

  late final List<NavigationModel> models = [
    NavigationModel(
      imagePath: "assets/images/book.png",
      title: "My Library",
      subtitle: "Browse, search & organize all flashcards",
      onTap: () => context.pushNamed(AppConstants.reviewCardsScreen, null),
    ),
    NavigationModel(
      imagePath: "assets/images/add.png",
      title: "New Flashcard",
      subtitle: "Create a new question & hint card",
      onTap: () => context.pushNamed(AppConstants.newCardScreen, null),
    ),
    NavigationModel(
      imagePath: "assets/images/quiz.png",
      title: "Start Quiz",
      subtitle: "MCQ or Smart Typing with fuzzy matching",
      onTap: () => context.pushNamed(AppConstants.quizScreen, null),
    ),
  ];

  static const List<Color> _optionAccents = [
    AppColors.primaryTeal,
    AppColors.emeraldGold,
    AppColors.softAmber,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpacing(16),
                    _buildHeader(),
                    verticalSpacing(20),
                    _buildHeroGreeting(),
                    verticalSpacing(20),
                  ],
                ),
              ),
            ),
            BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              builder: (context, state) {
                final cards =
                    state is CardsLoadedSuccess ? state.cards : <CardModel>[];
                final favCount =
                    cards.where((c) => c.isFavorite == true).length;
                final categories = cards
                    .map((c) => c.category ?? 'General')
                    .toSet()
                    .length;

                return CardsNumberContainer(
                  totalCards: cards.length,
                  favoriteCards: favCount,
                  categoriesCount: categories,
                );
              },
            ),
            sliverVerticalSpacing(24),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Topics & Genres",
                      style: AppStyles.font17BoldIceBlue.copyWith(
                        fontSize: 17.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      "Tap to filter",
                      style: AppStyles.font12LavenderGray.copyWith(
                        color: AppColors.lavenderGray.withValues(alpha: 0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            sliverVerticalSpacing(12),
            SliverToBoxAdapter(
              child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                builder: (context, state) {
                  final cards = state is CardsLoadedSuccess
                      ? state.cards
                      : <CardModel>[];
                  return _buildCategoryChipsRow(cards);
                },
              ),
            ),
            sliverVerticalSpacing(24),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Quick Actions",
                  style: AppStyles.font17BoldIceBlue.copyWith(
                    fontSize: 17.sp,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            sliverVerticalSpacing(12),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: models.length,
                  (context, index) => HomeOptionTile(
                    model: models[index],
                    accentColor: _optionAccents[index % _optionAccents.length],
                  ),
                ),
              ),
            ),
            sliverVerticalSpacing(24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.25),
            ),
          ),
          child: Icon(
            CupertinoIcons.sparkles,
            color: AppColors.primaryTeal,
            size: 18.sp,
          ),
        ),
        horizontalSpacing(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REVIO",
              style: AppStyles.font24BoldPrimaryManrope.copyWith(
                fontSize: 20.sp,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            "v2.0",
            style: AppStyles.font11GrayRegular.copyWith(
              color: AppColors.primaryTeal,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back! 👋",
          style: AppStyles.font24BoldIceBlueManrope.copyWith(
            fontSize: 26.sp,
            height: 1.2,
          ),
        ),
        verticalSpacing(6),
        Text(
          "Master your decks & test your memory effortlessly.",
          style: AppStyles.font14White70.copyWith(
            fontSize: 13.5.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChipsRow(List<CardModel> cards) {
    final categories = ["All", ...AppConstants.categories];

    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (context, index) => horizontalSpacing(8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategoryFilter == cat;
          final catColor = AppColors.categoryColors[cat] ?? AppColors.primaryTeal;
          final count = cat == "All"
              ? cards.length
              : cards.where((c) => c.category == cat).length;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategoryFilter = cat);
              context.pushNamed(AppConstants.reviewCardsScreen, null);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? catColor.withValues(alpha: 0.2)
                    : AppColors.cardSurface,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected
                      ? catColor
                      : AppColors.white.withValues(alpha: 0.08),
                  width: isSelected ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: catColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  horizontalSpacing(7),
                  Text(
                    cat,
                    style: AppStyles.font13GrayMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.lavenderGray,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12.5.sp,
                    ),
                  ),
                  horizontalSpacing(6),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "$count",
                      style: AppStyles.font11GrayRegular.copyWith(
                        color: catColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
