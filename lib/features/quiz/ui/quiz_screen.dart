import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/quiz/ui/widgets/buttons_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/logic/get_all_cards_cubit.dart';
import '../../../core/logic/get_all_cards_state.dart';
import '../../../core/widgets/flash_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isHintVisible = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Quiz Mode",
          style: AppStyles.font18BoldIndigoAccent,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
        builder: (context, state) {
          if (state is CardsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.indigoAccent),
            );
          }

          if (state is CardsError) {
            return Center(
              child: Text(
                "Error: ${state.errorMessage}",
                style: AppStyles.font16LavenderGray.copyWith(color: AppColors.error),
              ),
            );
          }

          if (state is CardsLoadedSuccess) {
            final cards = state.cards;

            if (cards.isEmpty) {
              return Center(
                child: Text(
                  "No cards available for quiz! 💡",
                  style: AppStyles.font14White70,
                ),
              );
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  children: [
                    Text(
                      "Card ${_currentPage + 1} of ${cards.length}",
                      style: AppStyles.font16LavenderGrayBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 240.h,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: cards.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                            _isHintVisible = false;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: FlashCard(
                              cardModel: cards[index],
                              isInQuiz: true,
                              showHint: _isHintVisible,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "💡 Tap card to flip | Swipe to change",
                      style: AppStyles.font12White38,
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        final currentCard = cards[_currentPage];

                        if (currentCard.hint != null &&
                            currentCard.hint!.trim().isNotEmpty) {
                          setState(() {
                            _isHintVisible = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "💡 No hint available for this card!",
                                style: AppStyles.font14WhiteSemiBold,
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.oceanBlue,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.lightbulb_fill,
                        color: Colors.amber,
                        size: 18,
                      ),
                      label: const Text("Show Hint"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ButtonsRow(
                      currentPage: _currentPage,
                      pageController: _pageController,
                      cards: cards,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
