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
            // ── Header + Greeting ────────────────────────────────────────────
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

            // ── Stats Container ──────────────────────────────────────────────
            BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              builder: (context, state) {
                final cards =
                    state is CardsLoadedSuccess ? state.cards : <CardModel>[];
                final favCount =
                    cards.where((c) => c.isFavorite == true).length;
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

            sliverVerticalSpacing(28),

            // ── Section label: Quick Actions ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Quick Actions",
                  style: AppStyles.font17BoldIceBlue.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            sliverVerticalSpacing(12),

            // ── Quick Actions ────────────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Hero: Start Quiz ─────────────────────────────────────
                    const HeroQuizCard(),
                    verticalSpacing(12),

                    // ── Row: My Library + New Card ───────────────────────────
                    BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                      builder: (context, state) {
                        final count = state is CardsLoadedSuccess
                            ? state.cards.length
                            : 0;
                        return Row(
                          children: [
                            Expanded(
                              child: _ActionCard(
                                icon: CupertinoIcons.book_fill,
                                title: "My Library",
                                subtitle: "$count cards",
                                accentColor: AppColors.primaryTeal,
                                onTap: () => context.pushNamed(
                                  AppConstants.reviewCardsScreen,
                                  null,
                                ),
                              ),
                            ),
                            horizontalSpacing(12),
                            Expanded(
                              child: _ActionCard(
                                icon: CupertinoIcons.add_circled_solid,
                                title: "New Card",
                                subtitle: "Add a flashcard",
                                accentColor: AppColors.emeraldGold,
                                onTap: () => context.pushNamed(
                                  AppConstants.newCardScreen,
                                  null,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    verticalSpacing(12),

                    // ── Genres wide card ─────────────────────────────────────
                    BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                      builder: (context, state) {
                        final activeCore =
                            CategoryManager.getActiveCoreCategories();
                        final custom = CategoryManager.getCustomCategories();
                        final count = activeCore.length + custom.length;
                        return _GenresWideCard(
                          count: count,
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

// ─────────────────────────────────────────────────────────────────────────────
// Private widget: compact action card (for the 2-column row)
// ─────────────────────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 22.sp),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: accentColor.withValues(alpha: 0.5),
                  size: 13.sp,
                ),
              ],
            ),
            verticalSpacing(14),
            // Title
            Text(
              title,
              style: AppStyles.font16WhiteSemiBold.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalSpacing(3),
            // Subtitle
            Text(
              subtitle,
              style: AppStyles.font12LavenderGrayFaded.copyWith(
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widget: wide Genres card (full width, horizontal layout)
// ─────────────────────────────────────────────────────────────────────────────
class _GenresWideCard extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _GenresWideCard({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const accentColor = AppColors.softAmber;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.28),
                ),
              ),
              child: const Icon(
                CupertinoIcons.tag_fill,
                color: accentColor,
              ),
            ),
            horizontalSpacing(16),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Genres",
                    style: AppStyles.font16WhiteSemiBold.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  verticalSpacing(3),
                  Text(
                    "$count categories · Manage & organise",
                    style: AppStyles.font12LavenderGrayFaded.copyWith(
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              CupertinoIcons.chevron_right,
              color: accentColor.withValues(alpha: 0.55),
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }
}
