import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/routing_extension.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

class AppSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: builder,
    );
  }
}

class AppSheetFrame extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final List<Widget>? actions;

  const AppSheetFrame({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            border: Border.all(
              color: AppColors.primaryCyan.withValues(alpha: 0.22),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.only(
            bottom: bottomInset + 18.h,
            left: 20.w,
            right: 20.w,
            top: 10.h,
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44.w,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.lavenderGray.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  verticalSpacing(16),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.darkBackground,
                          size: 18.sp,
                        ),
                      ),
                      horizontalSpacing(12),
                      Expanded(
                        child: Text(
                          title,
                          style: AppStyles.font18BoldIndigoAccent.copyWith(
                            fontSize: 19.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.cardSurface,
                          padding: EdgeInsets.all(8.w),
                        ),
                        icon: Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.lavenderGray,
                          size: 16.sp,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                  verticalSpacing(18),
                  child,
                  if (actions != null) ...[verticalSpacing(22), ...actions!],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
