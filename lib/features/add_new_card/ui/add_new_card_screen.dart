import 'package:code_alpha_flash_card_app/core/constants/app_constants.dart';
import 'package:code_alpha_flash_card_app/core/widgets/app_background_glow.dart';
import 'package:code_alpha_flash_card_app/core/widgets/genre_chip_picker.dart';
import 'package:code_alpha_flash_card_app/features/add_new_card/ui/widgets/app_text_form.dart';
import 'package:code_alpha_flash_card_app/features/add_new_card/ui/widgets/appbar_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import 'widgets/card_form_back_scope.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _hintController = TextEditingController();
  final _answerController = TextEditingController();
  String _selectedCategory = AppConstants.categories.first;

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardFormBackScope(
      questionController: _questionController,
      hintController: _hintController,
      answerController: _answerController,
      child: AppBackgroundGlow(
        variant: GlowVariant.addCard,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: AppbarBody(
                        questionController: _questionController,
                        hintController: _hintController,
                        answerController: _answerController,
                        selectedCategory: _selectedCategory,
                        formKey: _formKey,
                      ),
                    ),
                    sliverVerticalSpacing(20),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionLabel(label: "Genre / Category"),
                          verticalSpacing(10),
                          GenreChipPicker(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (cat) =>
                                setState(() => _selectedCategory = cat),
                          ),
                          verticalSpacing(24),
                          _SectionLabel(label: "Question (Front)"),
                          verticalSpacing(10),
                          AppTextForm(
                            controller: _questionController,
                            hint: "What do you want to remember?",
                            maxLines: 3,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter a question';
                              }
                              return null;
                            },
                          ),
                          verticalSpacing(20),
                          _SectionLabel(
                            label: "Hint",
                            badge: "Optional",
                          ),
                          verticalSpacing(10),
                          AppTextForm(
                            controller: _hintController,
                            maxLines: 2,
                            hint: "A small clue to help recall...",
                          ),
                          verticalSpacing(20),
                          _SectionLabel(label: "Answer (Back)"),
                          verticalSpacing(10),
                          AppTextForm(
                            controller: _answerController,
                            maxLines: 4,
                            hint: "The answer or explanation...",
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter an answer';
                              }
                              return null;
                            },
                          ),
                          verticalSpacing(40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? badge;

  const _SectionLabel({required this.label, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.font16LavenderGray.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.lavenderGray,
          ),
        ),
        if (badge != null) ...[
          horizontalSpacing(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: AppColors.primaryTeal.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              badge!,
              style: AppStyles.font11GrayRegular.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
