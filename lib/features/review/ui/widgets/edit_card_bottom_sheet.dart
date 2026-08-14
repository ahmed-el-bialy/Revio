import 'package:code_alpha_flash_card_app/core/data/models/card_model.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_styles.dart';
import 'package:code_alpha_flash_card_app/features/add_new_card/ui/widgets/app_text_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';

class EditCardBottomSheet extends StatefulWidget {
  final CardModel cardModel;
  final Function(CardModel updatedCard) onCardUpdated;

  const EditCardBottomSheet({
    super.key,
    required this.cardModel,
    required this.onCardUpdated,
  });

  @override
  State<EditCardBottomSheet> createState() => _EditCardBottomSheetState();
}

class _EditCardBottomSheetState extends State<EditCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _hintController;
  late final TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.cardModel.front);
    _hintController = TextEditingController(text: widget.cardModel.hint ?? '');
    _answerController = TextEditingController(text: widget.cardModel.back);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 16.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              verticalSpacing(20),
              Text(
                "Edit Question (Front)",
                style: AppStyles.font16LavenderGray,
              ),
              verticalSpacing(10),
              AppTextForm(
                controller: _questionController,
                hint: "Enter the question...",
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              verticalSpacing(15),
              Text("Edit Hint (Optional)", style: AppStyles.font16LavenderGray),
              verticalSpacing(10),
              AppTextForm(
                controller: _hintController,
                hint: "Enter a helpful hint...",
                maxLines: 2,
              ),
              verticalSpacing(15),
              Text("Edit Answer (Back)", style: AppStyles.font16LavenderGray),
              verticalSpacing(10),
              AppTextForm(
                controller: _answerController,
                hint: "Enter the answer...",
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              verticalSpacing(24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.oceanBlue,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedCard = CardModel(
                        id: widget.cardModel.id,
                        front: _questionController.text.trim(),
                        hint: _hintController.text.trim().isEmpty
                            ? null
                            : _hintController.text.trim(),
                        back: _answerController.text.trim(),
                      );

                      widget.onCardUpdated(updatedCard);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Save Changes",
                    style: AppStyles.font17WhiteBold.copyWith(fontSize: 16.sp),
                  ),
                ),
              ),
              verticalSpacing(20),
            ],
          ),
        ),
      ),
    );
  }
}
