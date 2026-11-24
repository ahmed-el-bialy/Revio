// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';
import 'press_scale_widget.dart';

/// A modern, eye-friendly, solid surface card replacing glassmorphism.
/// Features a matte dark background, crisp subtle border, and optional tap action.
class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius.r);

    final cardWidget = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardSurface,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? AppColors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return PressScale(
        onTap: onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
