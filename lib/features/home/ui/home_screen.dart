import 'package:code_alpha_flash_card_app/core/helpers/category_manager.dart';
import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/core/widgets/app_background_glow.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.home,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──────────────────────────────────────────────────────
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

            // ── Stats Row ────────────────────────────────────────────────────
            BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              builder: (context, state) {
                final cards =
                    state is CardsLoadedSuccess ? state.cards : <CardModel>[];
                final favCount =
                    cards.where((c) => c.isFavorite == true).length;
                final activeCore =
                    CategoryManager.getActiveCoreCategories();
                final custom = CategoryManager.getCustomCategories();
                final categoriesCount = activeCore.length + custom.length;

                return CardsNumberContainer(
                  totalCards: cards.length,
                  favoriteCards: favCount,
                  categoriesCount: categoriesCount,
                );
              },
            ),

            sliverVerticalSpacing(30),

            // ── Quick Actions label ──────────────────────────────────────────
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

            // ── Quick Actions Cards ──────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Hero Quiz Card — full width
                    const HeroQuizCard(),
                    verticalSpacing(14),

                    // Row 1: My Library + New Card
                    Row(
                      children: [
                        // My Library
                        Expanded(
                          child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                            builder: (context, state) {
                              final cards = state is CardsLoadedSuccess
                                  ? state.cards
                                  : <CardModel>[];
                              return QuickActionCard(
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

                        // New Card
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

                    verticalSpacing(14),

                    // Row 2: Genres — full width
                    BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                      builder: (context, state) {
                        final activeCore =
                            CategoryManager.getActiveCoreCategories();
                        final custom = CategoryManager.getCustomCategories();
                        final count = activeCore.length + custom.length;
                        return QuickActionCard(
                          icon: CupertinoIcons.tag_fill,
                          title: "Genres",
                          subtitle: "$count categories",
                          accentColor: AppColors.softAmber,
                          onTap: () => context.pushNamed(
                            AppConstants.genresScreen,
                            null,
                          ),
                        );
                      },
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
