import 'package:code_alpha_flash_card_app/core/helpers/spacing.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/cards_number_container.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/widgets/home_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/logic/get_all_cards_cubit.dart';
import '../../../core/logic/get_all_cards_state.dart';
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
      title: "Master Your Cards",
      subtitle: "Review and refine your knowledge",
      onTap: () {
        context.pushNamed(AppConstants.reviewCardsScreen, null);
      },
    ),
    NavigationModel(
      imagePath: "assets/images/add.png",
      title: "Expand Library",
      subtitle: "Create new powerful flashcards",
      onTap: () {
        context.pushNamed(AppConstants.newCardScreen, null);
      },
    ),
    NavigationModel(
      imagePath: "assets/images/quiz.png",
      title: "Challenge Yourself",
      subtitle: "Test your speed and accuracy",
      onTap: () {
        context.pushNamed(AppConstants.quizScreen, null);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              sliverVerticalSpacing(10),
              SliverToBoxAdapter(
                child: Text(
                  "Revio",
                  style: AppStyles.font24BoldIndigoAccentManrope.copyWith(
                    fontSize: 22.sp,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              sliverVerticalSpacing(20),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Learning Hub",
                      style: AppStyles.font24BoldIceBlueManrope.copyWith(
                        fontSize: 28.sp,
                      ),
                    ),
                    verticalSpacing(8),
                    Text(
                      "Elevate your knowledge with ease.",
                      style: AppStyles.font16LavenderGray.copyWith(
                        color: AppColors.lavenderGray.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              sliverVerticalSpacing(24),
              BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
                buildWhen: (previous, current) => current is CardsLoadedSuccess,
                builder: (context, state) {
                  final totalCards = (state is CardsLoadedSuccess)
                      ? state.cards.length
                      : 0;

                  return CardsNumberContainer(totalCards: totalCards);
                },
              ),
              sliverVerticalSpacing(32),
              SliverToBoxAdapter(
                child: Text(
                  "What's your focus today?",
                  style: AppStyles.font17BoldIceBlue.copyWith(
                    fontSize: 18.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              sliverVerticalSpacing(12),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: models.length,
                  (context, index) {
                    return HomeOptionTile(model: models[index]);
                  },
                ),
              ),
              sliverVerticalSpacing(20),
            ],
          ),
        ),
      ),
    );
  }
}
