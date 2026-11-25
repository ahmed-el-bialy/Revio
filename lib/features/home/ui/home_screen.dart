import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/category_manager.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';
import '../../quiz/data/repo/quiz_history_repo.dart';
import 'widgets/action_card.dart';
import 'widgets/cards_number_container.dart';
import 'widgets/genres_wide_card.dart';
import 'widgets/hero_quiz_card.dart';
import 'widgets/home_hero_greeting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = QuizHistoryRepo().getAllResults();
    final lastResult = history.isNotEmpty ? history.first : null;

    return AppBackgroundGlow(
      variant: GlowVariant.home,
      child: Scaffold(
        drawer: const AppDrawer(currentRoute: AppConstants.homeScreen),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: Icon(
                CupertinoIcons.bars,
                color: AppColors.white,
                size: 22.sp,
              ),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Text(
            "REVIO",
            style: AppStyles.font20BoldWhite.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  "v2.5",
                  style: AppStyles.font11GrayRegular.copyWith(
                    color: AppColors.primaryCyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
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
                          verticalSpacing(8),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const HeroQuizCard(),
                          verticalSpacing(12),
                          // Study Mode Banner
                          AppCard(
                            borderRadius: 20,
                            borderColor: AppColors.emeraldGold.withValues(alpha: 0.3),
                            padding: EdgeInsets.all(16.w),
                            onTap: () => context.pushNamed(AppConstants.studyScreen),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.emeraldGold.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.book_fill,
                                    color: AppColors.emeraldGold,
                                    size: 22.sp,
                                  ),
                                ),
                                horizontalSpacing(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Study Mode",
                                        style: AppStyles.font16WhiteSemiBold.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      verticalSpacing(2),
                                      Text(
                                        "Flip cards & learn at your own pace",
                                        style: AppStyles.font13GrayMedium.copyWith(
                                          color: AppColors.lavenderGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  color: AppColors.emeraldGold,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                          verticalSpacing(12),
                          // Flashcard Deck Banner
                          AppCard(
                            borderRadius: 20,
                            borderColor: AppColors.primaryCyan
                                .withValues(alpha: 0.25),
                            padding: EdgeInsets.all(16.w),
                            onTap: () => context
                                .pushNamed(AppConstants.reviewDeckScreen),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryCyan
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.layers_fill,
                                    color: AppColors.primaryCyan,
                                    size: 22.sp,
                                  ),
                                ),
                                horizontalSpacing(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Flashcard Review Deck",
                                        style: AppStyles.font16WhiteSemiBold
                                            .copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      verticalSpacing(2),
                                      Text(
                                        "Flip & study cards at your own pace",
                                        style: AppStyles.font13GrayMedium
                                            .copyWith(
                                          color: AppColors.lavenderGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.chevron_right,
                                  color: AppColors.primaryCyan,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                          verticalSpacing(16),
                          // Recent Quiz Activity
                          if (lastResult != null) ...[
                            AppCard(
                              borderRadius: 20,
                              borderColor: AppColors.white.withValues(alpha: 0.08),
                              padding: EdgeInsets.all(16.w),
                              onTap: () => context
                                  .pushNamed(AppConstants.quizHistoryScreen),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.indigoAccent
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.clock_fill,
                                      color: AppColors.indigoAccent,
                                      size: 22.sp,
                                    ),
                                  ),
                                  horizontalSpacing(14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Recent Quiz: ${lastResult.modeName}",
                                          style: AppStyles.font16WhiteSemiBold
                                              .copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        verticalSpacing(2),
                                        Text(
                                          "Score: ${lastResult.scorePercentage.toStringAsFixed(0)}% (${lastResult.correctCount}/${lastResult.totalCards})",
                                          style: AppStyles.font13GrayMedium
                                              .copyWith(
                                            color: AppColors.lavenderGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_right,
                                    color: AppColors.lavenderGray,
                                    size: 16.sp,
                                  ),
                                ],
                              ),
                            ),
                            verticalSpacing(16),
                          ],
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
                              final custom =
                                  CategoryManager.getCustomCategories();
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
      ),
    );
  }
}
