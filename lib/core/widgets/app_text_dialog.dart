import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/routing_extension.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';
import 'app_buttons.dart';

class AppTextDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final String hint;
  final String confirmLabel;
  final IconData icon;
  final String initialValue;
  final Future<String?> Function(String value) onSubmit;

  const AppTextDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hint,
    required this.confirmLabel,
    required this.onSubmit,
    this.icon = CupertinoIcons.tag_fill,
    this.initialValue = '',
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String hint,
    required String confirmLabel,
    required Future<String?> Function(String value) onSubmit,
    IconData icon = CupertinoIcons.tag_fill,
    String initialValue = '',
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => AppTextDialog(
        title: title,
        subtitle: subtitle,
        hint: hint,
        confirmLabel: confirmLabel,
        onSubmit: onSubmit,
        icon: icon,
        initialValue: initialValue,
      ),
    );
  }

  @override
  State<AppTextDialog> createState() => _AppTextDialogState();
}

class _AppTextDialogState extends State<AppTextDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      setState(() => _errorMessage = 'Please enter a name');
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final error = await widget.onSubmit(value);
    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _submitting = false;
      });
      return;
    }

    context.pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: AppColors.primaryCyan.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.primaryCyan,
                    size: 18.sp,
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppStyles.font18BoldIndigoAccent.copyWith(
                      fontSize: 18.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpacing(10),
            Text(
              widget.subtitle,
              style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
            ),
            verticalSpacing(16),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              style: AppStyles.font16WhiteSemiBold,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppStyles.font14White70,
                filled: true,
                fillColor: AppColors.cardSurface,
                errorText: _errorMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: AppColors.primaryCyan,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
            verticalSpacing(18),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    label: 'Cancel',
                    onPressed: _submitting ? null : () => context.pop(),
                  ),
                ),
                horizontalSpacing(12),
                Expanded(
                  child: AppButton.primary(
                    label: widget.confirmLabel,
                    loading: _submitting,
                    onPressed: _submitting ? null : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
