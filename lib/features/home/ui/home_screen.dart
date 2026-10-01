import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/core/widgets/genre_chip_picker.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/cards_number_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../cards/data/models/card_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryFilter = "All";

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
                final cards = state is CardsLoadedSuccess
                    ? state.cards
                    : <CardModel>[];
                final favCount = cards
                    .where((c) => c.isFavorite == true)
                    .length;
                final categoriesCount = cards
                    .map((c) => c.category ?? 'General')
                    .toSet()
                    .length;

                return CardsNumberContainer(
                  totalCards: cards.length,
                  favoriteCards: favCount,
                  categoriesCount: categoriesCount,
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
                      "Core & Custom",
                      style: AppStyles.font12LavenderGray.copyWith(
                        color: AppColors.primaryTeal,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
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
                  final customCats = cards
                      .map((c) => c.category ?? 'General')
                      .where((cat) => cat != 'All')
                      .toSet()
                      .toList();

                  return GenreChipPicker(
                    selectedCategory: _selectedCategoryFilter,
                    includeAllOption: true,
                    customCategories: customCats,
                    onCategorySelected: (cat) {
                      setState(() => _selectedCategoryFilter = cat);
                      context.pushNamed(AppConstants.reviewCardsScreen, null);
                    },
                  );
                },
              ),
            ),
            sliverVerticalSpacing(28),
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
            sliverVerticalSpacing(14),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeroQuizCard(),
                    verticalSpacing(14),
                    Row(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                                builder: (context, state) {
                                  final cards = state is CardsLoadedSuccess
                                      ? state.cards
                                      : <CardModel>[];
                                  return _buildQuickGridCard(
                                    icon: CupertinoIcons.book_fill,
                                    title: "My Library",
                                    subtitle: "${cards.length} Flashcards",
                                    accentColor: AppColors.primaryTeal,
                                    onTap: () => context.pushNamed(
                                      AppConstants.reviewCardsScreen,
                                      null,
                                    ),
                                  );
                                },
                              ),
                        ),
                        horizontalSpacing(14),
                        Expanded(
                          child: _buildQuickGridCard(
                            icon: CupertinoIcons.add_circled_solid,
                            title: "New Card",
                            subtitle: "Create Question",
                            accentColor: AppColors.emeraldGold,
                            onTap: () => context.pushNamed(
                              AppConstants.newCardScreen,
                              null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            sliverVerticalSpacing(30),
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
          style: AppStyles.font14White70.copyWith(fontSize: 13.5.sp),
        ),
      ],
    );
  }

  Widget _buildHeroQuizCard() {
    return GestureDetector(
      onTap: () => context.pushNamed(AppConstants.quizScreen, null),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.softAmber.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softAmber.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.softAmber.withValues(alpha: 0.25),
                    AppColors.softAmber.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: AppColors.softAmber.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                CupertinoIcons.bolt_fill,
                color: AppColors.softAmber,
                size: 28.sp,
              ),
            ),
            horizontalSpacing(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Start Quiz Challenge",
                        style: AppStyles.font18WhiteBold.copyWith(
                          fontSize: 16.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      horizontalSpacing(6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softAmber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "SMART",
                          style: AppStyles.font11GrayRegular.copyWith(
                            color: AppColors.softAmber,
                            fontWeight: FontWeight.w800,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpacing(4),
                  Text(
                    "MCQ & Smart Typing with fuzzy matching",
                    style: AppStyles.font12LavenderGrayFaded.copyWith(
                      fontSize: 12.sp,
                    ),
                  ),
                  verticalSpacing(10),
                  Row(
                    children: [
                      Text(
                        "Play Quiz Now",
                        style: AppStyles.font13GrayMedium.copyWith(
                          color: AppColors.softAmber,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5.sp,
                        ),
                      ),
                      horizontalSpacing(4),
                      Icon(
                        CupertinoIcons.arrow_right,
                        color: AppColors.softAmber,
                        size: 13.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 22.sp),
                ),
                Icon(
                  CupertinoIcons.chevron_forward,
                  color: accentColor.withValues(alpha: 0.6),
                  size: 14.sp,
                ),
              ],
            ),
            verticalSpacing(14),
            Text(
              title,
              style: AppStyles.font16WhiteSemiBold.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpacing(3),
            Text(
              subtitle,
              style: AppStyles.font12LavenderGrayFaded.copyWith(
                fontSize: 11.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
