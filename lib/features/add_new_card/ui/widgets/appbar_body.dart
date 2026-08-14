import 'package:code_alpha_flash_card_app/core/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data/models/card_model.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../logic/add_card_cubit.dart';
import '../../logic/add_card_state.dart';

class AppbarBody extends StatelessWidget {
  const AppbarBody({
    super.key,
    required this._questionController,
    required this._hintController,
    required this._answerController,
    required this._formKey,
  });

  final TextEditingController _questionController;
  final TextEditingController _hintController;
  final TextEditingController _answerController;
  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              if (_questionController.text.isNotEmpty ||
                  _hintController.text.isNotEmpty ||
                  _answerController.text.isNotEmpty) {
                FocusScope.of(context).unfocus();
              }
              Navigator.maybePop(context);
            },
            child: Text(
              "Cancel",
              style: AppStyles.font16LavenderGrayBold,
            ),
          ),
        ),

        const Spacer(),

        Text(
          "New Card",
          style: AppStyles.font18BoldIndigoAccent,
        ),

        const Spacer(),

        BlocConsumer<AddCardCubit, AddCardState>(
          listener: (context, state) {
            if (state is AddCardSuccess) {
              SnackBarHelper.showSuccess(
                  context, 'The card is saved successfully! 🎉');
              Navigator.pop(context);
            } else if (state is AddCardError) {
              SnackBarHelper.showError(context, state.error);
            }
          },
          builder: (context, state) {
            return InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: state is AddCardLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        final newCard = CardModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          front: _questionController.text.trim(),
                          hint: _hintController.text.trim().isEmpty
                              ? null
                              : _hintController.text.trim(),
                          back: _answerController.text.trim(),
                        );
                        context.read<AddCardCubit>().emitSaveCard(newCard);
                      }
                    },
              child: Container(
                constraints: BoxConstraints(minWidth: 60.w),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.indigoAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.indigoAccent.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: state is AddCardLoading
                    ? SizedBox(
                        height: 16.h,
                        width: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.indigoAccent,
                          ),
                        ),
                      )
                    : Text(
                        "Save",
                        style: AppStyles.font24BoldIndigoAccentManrope.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}
