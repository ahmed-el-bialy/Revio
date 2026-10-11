import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';
import 'press_scale_widget.dart';

/// A premium Glassmorphic Container matching Revio UI mockups (Image 1 & 2),
/// featuring frosted glass blur, glowing cyan border highlights, and dark obsidian surface.
class AppGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? accentColor;
  final double blurSigma;
  final double borderOpacity;
  final double backgroundOpacity;
  final VoidCallback? onTap;

  const AppGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 22,
    this.accentColor,
    this.blurSigma = 12,
    this.borderOpacity = 0.28,
    this.backgroundOpacity = 0.75,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveAccent = accentColor ?? AppColors.primaryCyan;
    final radius = BorderRadius.circular(borderRadius.r);

    final widgetChild = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: effectiveAccent.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding ?? EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              borderRadius: radius,
              color: AppColors.cardSurface.withValues(alpha: backgroundOpacity),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  effectiveAccent.withValues(alpha: 0.12),
                  AppColors.surfaceDark.withValues(alpha: backgroundOpacity),
                ],
              ),
              border: Border.all(
                color: effectiveAccent.withValues(alpha: borderOpacity),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return PressScale(
        onTap: onTap,
        child: widgetChild,
      );
    }

    return widgetChild;
  }
}
