import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';

class LibraryEmptyState extends StatefulWidget {
  final bool hasCardsOverall;

  const LibraryEmptyState({
    super.key,
    this.hasCardsOverall = true,
  });

  @override
  State<LibraryEmptyState> createState() => _LibraryEmptyStateState();
}

class _LibraryEmptyStateState extends State<LibraryEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 36.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    reduceMotion ? 0 : _floatAnimation.value,
                  ),
                  child: child,
                );
              },
              child: Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryTeal.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.primaryTeal.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    widget.hasCardsOverall
                        ? CupertinoIcons.search
                        : CupertinoIcons.square_stack_3d_up_fill,
                    size: 46.sp,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ),
            verticalSpacing(24),
            Text(
              widget.hasCardsOverall
                  ? "No matching cards found"
                  : "Your library is ready",
              style: AppStyles.font20BoldWhite.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(10),
            Text(
              widget.hasCardsOverall
                  ? "We couldn't find any cards matching your filter. Try clearing your search or switching topics."
                  : "Start building your flashcard collection! Tap '+' to create your first card and power up your memory.",
              style: AppStyles.font14White70.copyWith(
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
