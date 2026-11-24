import 'package:cupertino_ui/cupertino_ui.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.home,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpacing(12),
                        const HomeHeader(),
                        verticalSpacing(16),
                        const HomeHeroGreeting(),
                        verticalSpacing(18),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                    builder: (context, state) {
                      final cards = state is CardsLoadedSuccess
                          ? state.cards
                          : <CardModel>[];
                      final favCount =
                          cards.where((c) => c.isFavorite == true).length;
                      final activeCore =
                          CategoryManager.getActiveCoreCategories();
                      final custom = CategoryManager.getCustomCategories();
                      final categoriesCount =
                          activeCore.length + custom.length;

                      return CardsNumberContainer(
                        totalCards: cards.length,
                        favoriteCards: favCount,
                        categoriesCount: categoriesCount,
                      );
                    },
                  ),
                ),
                sliverVerticalSpacing(20),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                sliverVerticalSpacing(10),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const HeroQuizCard(),
                        verticalSpacing(12),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.folder_fill,
                              color: AppColors.indigoAccent,
                              size: 17.sp,
                            ),
                            horizontalSpacing(8),
                            Text(
                              "Your Library",
                              style: AppStyles.font17BoldIceBlue.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        verticalSpacing(10),
                        BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                          builder: (context, state) {
                            final count = state is CardsLoadedSuccess
                                ? state.cards.length
                                : 0;
                            return Row(
                              children: [
                                Expanded(
                                  child: ActionCard(
                                    icon: CupertinoIcons.book_fill,
                                    title: "Library",
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
                                    subtitle: "Create flashcard",
                                    accentColor: AppColors.indigoAccent,
                                    onTap: () => context.pushNamed(
                                      AppConstants.newCardScreen,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        verticalSpacing(12),
                        BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                          builder: (context, state) {
                            final activeCore =
                                CategoryManager.getActiveCoreCategories();
                            final custom = CategoryManager.getCustomCategories();
                            final count = activeCore.length + custom.length;
                            return GenresWideCard(
                              count: count,
                              onTap: () => context.pushNamed(
                                AppConstants.genresScreen,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                sliverVerticalSpacing(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
