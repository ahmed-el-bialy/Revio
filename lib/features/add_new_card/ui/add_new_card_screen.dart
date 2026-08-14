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
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
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
                      formKey: _formKey,
                    ),
                  ),
                  sliverVerticalSpacing(15),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpacing(10),
                        Text(
                          "Question (Front)",
                          style: AppStyles.font16LavenderGray,
                        ),
                        verticalSpacing(10),
                        AppTextForm(
                          controller: _questionController,
                          hint: "Enter the question here...",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a question';
                            }
                            return null;
                          },
                          maxLines: 3,
                        ),
                        verticalSpacing(20),
                        Text(
                          "Hint (Optional)",
                          style: AppStyles.font16LavenderGray,
                        ),
                        verticalSpacing(10),
                        AppTextForm(
                          controller: _hintController,
                          maxLines: 2,
                          hint: "Enter a helpful hint...",
                        ),
                        verticalSpacing(20),
                        Text(
                          "Answer (Back)",
                          style: AppStyles.font16LavenderGray,
                        ),
                        verticalSpacing(10),
                        AppTextForm(
                          controller: _answerController,
                          maxLines: 4,
                          hint: "Enter the answer or explanation...",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an answer';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
