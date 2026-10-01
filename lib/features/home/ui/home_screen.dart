import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/cards_number_container.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/home_option_tile.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_cubit.dart';
import 'package:code_alpha_flash_card_app/features/cards/logic/get_all_cards_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
import '../models/navigation_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<NavigationModel> models = [
    NavigationModel(
      imagePath: "assets/images/book.png",
      title: "My Library",
      subtitle: "Browse, search & manage all your flashcards",
      onTap: () => context.pushNamed(AppConstants.reviewCardsScreen, null),
    ),
    NavigationModel(
      imagePath: "assets/images/add.png",
      title: "New Card",
      subtitle: "Create a new flashcard with a category",
      onTap: () => context.pushNamed(AppConstants.newCardScreen, null),
    ),
    NavigationModel(
      imagePath: "assets/images/quiz.png",
      title: "Start Quiz",
      subtitle: "MCQ or Typing mode — smart answer matching",
      onTap: () => context.pushNamed(AppConstants.quizScreen, null),
    ),
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
                    verticalSpacing(24),
                    _buildHeroSection(),
                  ],
                ),
              ),
            ),
            sliverVerticalSpacing(20),
            BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
              buildWhen: (previous, current) => current is CardsLoadedSuccess,
              builder: (context, state) {
                final cards =
                    state is CardsLoadedSuccess ? state.cards : const [];
                final favCount =
                    cards.where((c) => c.isFavorite == true).length;
                return CardsNumberContainer(
                  totalCards: cards.length,
                  favoriteCards: favCount,
                );
              },
            ),
            sliverVerticalSpacing(28),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  "Quick Actions",
                  style: AppStyles.font17BoldIceBlue.copyWith(
                    fontSize: 17.sp,
                    letterSpacing: 0.4,
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
                  (context, index) => HomeOptionTile(model: models[index]),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Revio",
              style: AppStyles.font24BoldPrimaryManrope.copyWith(
                fontSize: 20.sp,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: AppColors.primaryTeal.withValues(alpha: 0.3)),
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

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Learning\nHub",
          style: AppStyles.font24BoldIceBlueManrope.copyWith(
            fontSize: 30.sp,
            height: 1.25,
          ),
        ),
        verticalSpacing(8),
        Text(
          "Elevate your knowledge, one card at a time.",
          style: AppStyles.font14White70,
        ),
      ],
    );
  }
}
