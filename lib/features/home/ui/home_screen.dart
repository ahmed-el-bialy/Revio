import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/category_manager.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import 'widgets/action_card.dart';
import 'widgets/cards_number_container.dart';
import 'widgets/genres_wide_card.dart';
import 'widgets/hero_quiz_card.dart';
import 'widgets/home_header.dart';
import 'widgets/home_hero_greeting.dart';
import 'widgets/motivational_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildStaggered({
    required double begin,
    required double end,
    required Widget child,
  }) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) return child;

    final animation = CurvedAnimation(
      parent: _animController,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1.0 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

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
              child: _buildStaggered(
                begin: 0.0,
                end: 0.45,
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

                return _buildStaggered(
                  begin: 0.15,
                  end: 0.60,
                  child: CardsNumberContainer(
                    totalCards: cards.length,
                    favoriteCards: favCount,
                    categoriesCount: categoriesCount,
                  ),
                );
              },
            ),

            sliverVerticalSpacing(24),

            // ── Section label: Quick Actions ─────────────────────────────────
            SliverToBoxAdapter(
              child: _buildStaggered(
                begin: 0.30,
                end: 0.70,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.bolt_fill,
                            color: AppColors.primaryCyan,
                            size: 18.sp,
                          ),
                          horizontalSpacing(8),
                          Text(
                            "Quick Actions",
                            style: AppStyles.font17BoldIceBlue.copyWith(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "See all ->",
                        style: AppStyles.font13GrayMedium.copyWith(
                          color: AppColors.primaryCyan,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            sliverVerticalSpacing(12),

            // ── Quick Actions Grid ───────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Hero: Start Quiz Challenge ───────────────────────────
                    _buildStaggered(
                      begin: 0.40,
                      end: 0.80,
                      child: const HeroQuizCard(),
                    ),
                    verticalSpacing(14),

                    // ── Section label: Your Content ──────────────────────────
                    _buildStaggered(
                      begin: 0.48,
                      end: 0.85,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.folder_fill,
                            color: AppColors.primaryCyan,
                            size: 17.sp,
                          ),
                          horizontalSpacing(8),
                          Text(
                            "Your Content",
                            style: AppStyles.font17BoldIceBlue.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing(10),

                    // ── Row: My Library + New Card ───────────────────────────
                    BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                      builder: (context, state) {
                        final count = state is CardsLoadedSuccess
                            ? state.cards.length
                            : 0;
                        return _buildStaggered(
                          begin: 0.55,
                          end: 0.90,
                          child: Row(
                            children: [
                              Expanded(
                                child: ActionCard(
                                  icon: CupertinoIcons.book_fill,
                                  title: "My Library",
                                  subtitle: "$count cards",
                                  accentColor: AppColors.primaryCyan,
                                  onTap: () => context.pushNamed(
                                    AppConstants.reviewCardsScreen,
                                  ),
                                ),
                              ),
                              horizontalSpacing(12),
                              Expanded(
                                child: ActionCard(
                                  icon: CupertinoIcons.add_circled_solid,
                                  title: "New Card",
                                  subtitle: "Add a flashcard",
                                  accentColor: AppColors.emeraldGold,
                                  onTap: () => context.pushNamed(
                                    AppConstants.newCardScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        return _buildStaggered(
                          begin: 0.62,
                          end: 0.95,
                          child: GenresWideCard(
                            count: count,
                            onTap: () => context.pushNamed(
                              AppConstants.genresScreen,
                            ),
                          ),
                        );
                      },
                    ),

                    verticalSpacing(14),

                    // ── Motivational Progress Banner ────────────────────────
                    _buildStaggered(
                      begin: 0.70,
                      end: 1.0,
                      child: const MotivationalBanner(),
                    ),
                  ],
                ),
              ),
            ),

            sliverVerticalSpacing(24),
          ],
        ),
      ),
    );
  }
}
