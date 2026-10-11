import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_colors.dart';

enum GlowVariant { home, quiz, review, addCard }

class AppBackgroundGlow extends StatefulWidget {
  final Widget child;
  final GlowVariant variant;

  const AppBackgroundGlow({
    super.key,
    required this.child,
    this.variant = GlowVariant.home,
  });

  @override
  State<AppBackgroundGlow> createState() => _AppBackgroundGlowState();
}

class _AppBackgroundGlowState extends State<AppBackgroundGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.80, end: 1.15).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          if (reduceMotion)
            ..._buildGlowsForVariant(widget.variant, 1.0, 1.0)
          else
            AnimatedBuilder(
              animation: _glowController,
              builder: (context, _) {
                return Stack(
                  children: _buildGlowsForVariant(
                    widget.variant,
                    _scaleAnimation.value,
                    _opacityAnimation.value,
                  ),
                );
              },
            ),
          widget.child,
        ],
      ),
    );
  }

  List<Widget> _buildGlowsForVariant(
      GlowVariant v, double scale, double opacityMultiplier) {
    switch (v) {
      case GlowVariant.home:
        return [
          Positioned(
            top: -70.h,
            left: -50.w,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 220.w,
                height: 220.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryTeal.withValues(
                    alpha: (0.12 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180.h,
            right: -80.w,
            child: Transform.scale(
              scale: 2.0 - scale, // counter-phase breathing for organic feeling
              child: Container(
                width: 260.w,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyberCyan.withValues(
                    alpha: (0.08 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120.h,
            left: -70.w,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 240.w,
                height: 240.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldGold.withValues(
                    alpha: (0.07 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ];
      case GlowVariant.quiz:
        return [
          Positioned(
            top: 40.h,
            right: -60.w,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 250.w,
                height: 250.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softAmber.withValues(
                    alpha: (0.10 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50.h,
            left: -50.w,
            child: Transform.scale(
              scale: 2.0 - scale,
              child: Container(
                width: 240.w,
                height: 240.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryTeal.withValues(
                    alpha: (0.09 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ];
      case GlowVariant.review:
        return [
          Positioned(
            top: -50.h,
            right: -40.w,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 230.w,
                height: 230.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyberCyan.withValues(
                    alpha: (0.10 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100.h,
            left: -60.w,
            child: Transform.scale(
              scale: 2.0 - scale,
              child: Container(
                width: 240.w,
                height: 240.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emeraldGold.withValues(
                    alpha: (0.08 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ];
      case GlowVariant.addCard:
        return [
          Positioned(
            top: 80.h,
            left: -60.w,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 240.w,
                height: 240.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryTeal.withValues(
                    alpha: (0.09 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30.h,
            right: -40.w,
            child: Transform.scale(
              scale: 2.0 - scale,
              child: Container(
                width: 230.w,
                height: 230.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softAmber.withValues(
                    alpha: (0.08 * opacityMultiplier).clamp(0.0, 1.0),
                  ),
                ),
              ),
            ),
          ),
        ];
    }
  }
}
