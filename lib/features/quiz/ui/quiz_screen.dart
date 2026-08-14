import 'package:code_alpha_flash_card_app/core/helpers/snackbar_helper.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/quiz/ui/widgets/buttons_row.dart';
import 'package:flip_card/flip_card.dart';
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
  final TextEditingController _answerController = TextEditingController();
  final GlobalKey<FlipCardState> _flipKey = GlobalKey<FlipCardState>();
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
    _answerController.dispose();
    super.dispose();
  }

  void _submitAnswer(String correctAnswer) {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final expectedAnswer = correctAnswer.trim().toLowerCase();

    // Flip the card to show the back
    if (_flipKey.currentState?.isFront ?? false) {
      _flipKey.currentState?.toggleCard();
    }

    if (userAnswer == expectedAnswer) {
      SnackBarHelper.showSuccess(context, "Correct! Well done! 🎉");
    } else {
      SnackBarHelper.showError(context, "Incorrect. Keep practicing! 💪");
    }
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
              child: SingleChildScrollView(
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
                      SizedBox(height: 30.h),
                      SizedBox(
                        height: 240.h,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(), // Disable swipe to force using buttons
                          itemCount: cards.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                              _isHintVisible = false;
                              _answerController.clear();
                              // Ensure new card starts from front
                              if (!(_flipKey.currentState?.isFront ?? true)) {
                                _flipKey.currentState?.toggleCard();
                              }
                            });
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: FlashCard(
                                flipKey: _flipKey,
                                cardModel: cards[index],
                                isInQuiz: true,
                                showHint: _isHintVisible,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      
                      // Answer Input Section
                      TextField(
                        controller: _answerController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type your answer here...",
                          hintStyle: AppStyles.font14White70,
                          filled: true,
                          fillColor: AppColors.oceanBlue.withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                        ),
                        onSubmitted: (_) => _submitAnswer(cards[_currentPage].back),
                      ),
                      SizedBox(height: 16.h),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _submitAnswer(cards[_currentPage].back),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.indigoAccent,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Submit Answer",
                            style: AppStyles.font14WhiteSemiBold.copyWith(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              final currentCard = cards[_currentPage];
                              if (currentCard.hint != null &&
                                  currentCard.hint!.trim().isNotEmpty) {
                                setState(() {
                                  _isHintVisible = true;
                                });
                              } else {
                                SnackBarHelper.showInfo(context, "No hint available for this card!");
                              }
                            },
                            icon: const Icon(CupertinoIcons.lightbulb, color: Colors.amber, size: 20),
                            label: Text("Need a Hint?", style: AppStyles.font14White70),
                          ),
                        ],
                      ),

                      SizedBox(height: 30.h),
                      
                      ButtonsRow(
                        currentPage: _currentPage,
                        pageController: _pageController,
                        cards: cards,
                      ),
                    ],
                  ),
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
