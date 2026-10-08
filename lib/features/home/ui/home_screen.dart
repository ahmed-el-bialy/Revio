import 'package:code_alpha_flash_card_app/core/helpers/category_manager.dart';
import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/core/widgets/app_background_glow.dart';
import 'package:code_alpha_flash_card_app/core/widgets/genre_chip_picker.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/cards_number_container.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/hero_quiz_card.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/home_header.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/home_hero_greeting.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/quick_action_card.dart';
import 'package:flutter/cupertino.dart';
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
    return AppBackgroundGlow(
      variant: GlowVariant.home,
      child: SafeArea(
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
                    const HomeHeader(),
                    verticalSpacing(20),
                    const HomeHeroGreeting(),
                    verticalSpacing(22),
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
                
                // Total topics count from CategoryManager (core + custom) regardless of card assignment
                final activeCore = CategoryManager.getActiveCoreCategories();
                final custom = CategoryManager.getCustomCategories();
                final categoriesCount = activeCore.length + custom.length;

                return CardsNumberContainer(
                  totalCards: cards.length,
                  favoriteCards: favCount,
                  categoriesCount: categoriesCount,
                );
              },
            ),
            sliverVerticalSpacing(26),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Topics & Genres",
                      style: AppStyles.font17BoldIceBlue.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context.pushNamed(
                            AppConstants.manageTopicsScreen, null);
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryTeal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.gear_alt_fill,
                              color: AppColors.primaryTeal,
                              size: 13.sp,
                            ),
                            horizontalSpacing(5),
                            Text(
                              "Manage",
                              style: AppStyles.font12LavenderGray.copyWith(
                                color: AppColors.primaryTeal,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenreChipPicker(
                        selectedCategory: _selectedCategoryFilter,
                        includeAllOption: true,
                        customCategories: customCats,
                        onCategorySelected: (cat) async {
                          setState(() => _selectedCategoryFilter = cat);
                          await context.pushNamed(AppConstants.reviewCardsScreen, cat);
                          if (mounted) {
                            setState(() => _selectedCategoryFilter = "All");
                          }
                        },
                      ),
                      if (customCats.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                CupertinoIcons.info_circle_fill,
                                color: AppColors.softAmber,
                                size: 16.sp,
                              ),
                              horizontalSpacing(8),
                              Expanded(
                                child: Text(
                                  "You don't have any topics yet! Tap 'Manage' to add some or create a new card.",
                                  style: AppStyles.font12LavenderGray.copyWith(
                                    color: AppColors.softAmber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            sliverVerticalSpacing(30),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Quick Actions",
                  style: AppStyles.font17BoldIceBlue.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
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
                    const HeroQuizCard(),
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
                                  final favCount = cards
                                      .where((c) => c.isFavorite == true)
                                      .length;
                                  return QuickActionCard(
                                    icon: CupertinoIcons.star_fill,
                                    title: "Favorites",
                                    subtitle: "$favCount Cards",
                                    accentColor: AppColors.softAmber,
                                    onTap: () => context.pushNamed(
                                      AppConstants.reviewCardsScreen,
                                      '__FAVORITES__',
                                    ),
                                  );
                                },
                              ),
                        ),
                        horizontalSpacing(14),
                        Expanded(
                          child: QuickActionCard(
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
            sliverVerticalSpacing(40),
          ],
        ),
      ),
    );
  }
}
