import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../cards/data/models/card_model.dart';
import 'flashcard_form_fields.dart';

class EditCardBottomSheet extends StatefulWidget {
  final CardModel cardModel;
  final Function(CardModel updatedCard) onCardUpdated;
  final VoidCallback? onDeleteCard;

  const EditCardBottomSheet({
    super.key,
    required this.cardModel,
    required this.onCardUpdated,
    this.onDeleteCard,
  });

  @override
  State<EditCardBottomSheet> createState() => _EditCardBottomSheetState();
}

class _EditCardBottomSheetState extends State<EditCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _hintController;
  late final TextEditingController _answerController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.cardModel.front);
    _hintController = TextEditingController(text: widget.cardModel.hint ?? '');
    _answerController = TextEditingController(text: widget.cardModel.back);
    _selectedCategory = widget.cardModel.category ?? AppConstants.defaultTopic;
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBackground.withValues(alpha: 0.6),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        left: 20.w,
        right: 20.w,
        top: 12.h,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.lavenderGray.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                verticalSpacing(18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryTeal.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            CupertinoIcons.pencil,
                            color: AppColors.darkBackground,
                            size: 18.sp,
                          ),
                        ),
                        horizontalSpacing(12),
                        Text(
                          "Edit Flashcard",
                          style: AppStyles.font18BoldIndigoAccent.copyWith(
                            fontSize: 20.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.cardSurface,
                        padding: EdgeInsets.all(8.w),
                      ),
                      icon: Icon(
                        CupertinoIcons.xmark,
                        color: AppColors.lavenderGray,
                        size: 18.sp,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                verticalSpacing(20),
                FlashcardFormFields(
                  questionController: _questionController,
                  hintController: _hintController,
                  answerController: _answerController,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                verticalSpacing(28),
                Row(
                  children: [
                    if (widget.onDeleteCard != null) ...[
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.favoriteColor.withValues(alpha: 0.15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            side: BorderSide(
                              color: AppColors.favoriteColor.withValues(alpha: 0.4),
                              width: 1.2,
                            ),
                          ),
                          padding: EdgeInsets.all(14.w),
                        ),
                        onPressed: () {
                          widget.onDeleteCard!();
                          context.pop();
                        },
                        icon: Icon(
                          CupertinoIcons.trash,
                          color: AppColors.favoriteColor,
                          size: 20.sp,
                        ),
                      ),
                      horizontalSpacing(12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryTeal,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedCard = CardModel(
                              id: widget.cardModel.id,
                              category: _selectedCategory,
                              front: _questionController.text.trim(),
                              hint: _hintController.text.trim().isEmpty
                                  ? null
                                  : _hintController.text.trim(),
                              back: _answerController.text.trim(),
                              isFavorite: widget.cardModel.isFavorite,
                              difficulty: widget.cardModel.difficulty,
                              createdAt: widget.cardModel.createdAt,
                            );

                            widget.onCardUpdated(updatedCard);
                            context.pop();
                          }
                        },
                        child: Text(
                          "Save Changes",
                          style: AppStyles.font17WhiteBold.copyWith(
                            color: AppColors.darkBackground,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
