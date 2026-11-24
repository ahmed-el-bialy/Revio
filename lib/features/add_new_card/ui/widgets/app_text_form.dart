import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class AppTextForm extends StatefulWidget {
  const AppTextForm({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    required this.maxLines,
    this.hintStyle,
    this.fillColor,
    this.textStyle,
  });

  final TextEditingController controller;
  final String hint;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final TextStyle? textStyle;

  @override
  State<AppTextForm> createState() => _AppTextFormState();
}

class _AppTextFormState extends State<AppTextForm> {
  bool _isArabic = false;

  @override
  void initState() {
    super.initState();
    _checkArabic(widget.controller.text);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    _checkArabic(widget.controller.text);
  }

  void _checkArabic(String text) {
    final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    if (hasArabic != _isArabic) {
      setState(() {
        _isArabic = hasArabic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: widget.textStyle ?? AppStyles.font16WhiteSemiBold,
      maxLines: widget.maxLines,
      textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
      textAlign: _isArabic ? TextAlign.right : TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? AppStyles.font14White70,
        fillColor: widget.fillColor ?? AppColors.white.withValues(alpha: 0.05),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
      validator: widget.validator,
    );
  }
}
