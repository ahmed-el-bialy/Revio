import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../constants/app_constants.dart';
import '../helpers/routing_extension.dart';
import '../helpers/spacing.dart';
import '../theming/app_colors.dart';
import '../theming/app_styles.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, this.currentRoute = AppConstants.homeScreen});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkBackground,
      child: SafeArea(
        child: Column(
          children: [
            verticalSpacing(16),
            // Header Branding
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.style_rounded,
                      color: AppColors.darkBackground,
                      size: 22.sp,
                    ),
                  ),
                  horizontalSpacing(14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "REVIO",
                        style: AppStyles.font20BoldWhite.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      verticalSpacing(2),
                      Text(
                        "Smart Flashcards",
                        style: AppStyles.font12LavenderGray.copyWith(
                          color: AppColors.primaryCyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            verticalSpacing(24),
            Divider(
              color: AppColors.white.withValues(alpha: 0.08),
              height: 1,
            ),
            verticalSpacing(16),
            // Drawer Navigation Tiles
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    _DrawerTile(
                      icon: CupertinoIcons.home,
                      label: "Dashboard",
                      isSelected: currentRoute == AppConstants.homeScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.homeScreen) {
                          context.pushAndRemoveUntil(
                            routeName: AppConstants.homeScreen,
                            predicate: (_) => false,
                          );
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.layers,
                      label: "Flashcard Deck",
                      isSelected: currentRoute == AppConstants.reviewDeckScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.reviewDeckScreen) {
                          context.pushNamed(AppConstants.reviewDeckScreen);
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.book,
                      label: "Study Mode",
                      isSelected: currentRoute == AppConstants.studyScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.studyScreen) {
                          context.pushNamed(AppConstants.studyScreen);
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.search,
                      label: "Card Library",
                      isSelected: currentRoute == AppConstants.reviewCardsScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.reviewCardsScreen) {
                          context.pushNamed(AppConstants.reviewCardsScreen);
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.bolt_fill,
                      label: "Quiz Arena",
                      isSelected: currentRoute == AppConstants.quizScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.quizScreen) {
                          context.pushNamed(AppConstants.quizScreen);
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.clock,
                      label: "Quiz History",
                      isSelected: currentRoute == AppConstants.quizHistoryScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.quizHistoryScreen) {
                          context.pushNamed(AppConstants.quizHistoryScreen);
                        }
                      },
                    ),
                    _DrawerTile(
                      icon: CupertinoIcons.tag_fill,
                      label: "Topics",
                      isSelected: currentRoute == AppConstants.genresScreen,
                      onTap: () {
                        context.pop();
                        if (currentRoute != AppConstants.genresScreen) {
                          context.pushNamed(AppConstants.genresScreen);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Quick Add Card Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCyan,
                    foregroundColor: AppColors.darkBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: () {
                    context.pop();
                    context.pushNamed(AppConstants.newCardScreen);
                  },
                  icon: Icon(
                    CupertinoIcons.add,
                    size: 18.sp,
                    color: AppColors.darkBackground,
                  ),
                  label: Text(
                    "Add Flashcard",
                    style: AppStyles.font16WhiteSemiBold.copyWith(
                      color: AppColors.darkBackground,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        tileColor: isSelected
            ? AppColors.primaryCyan.withValues(alpha: 0.15)
            : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryCyan : AppColors.lavenderGray,
          size: 20.sp,
        ),
        title: Text(
          label,
          style: AppStyles.font16WhiteSemiBold.copyWith(
            color: isSelected ? AppColors.primaryCyan : AppColors.white,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}
