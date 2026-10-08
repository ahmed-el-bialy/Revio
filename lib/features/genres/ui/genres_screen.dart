import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/category_manager.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/snackbar_helper.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  List<String> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
  }

  void _loadGenres() {
    final activeCore = CategoryManager.getActiveCoreCategories();
    final custom = CategoryManager.getCustomCategories();
    setState(() {
      _genres = [...activeCore, ...custom];
    });
  }

  void _showAddGenreDialog() {
    final textController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: AppColors.primaryTeal.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(CupertinoIcons.tag_fill,
                      color: AppColors.primaryTeal, size: 18.sp),
                ),
                horizontalSpacing(10),
                Text(
                  "Add New Genre",
                  style: AppStyles.font18BoldIndigoAccent.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create a new genre category for your flashcards.",
                  style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
                ),
                verticalSpacing(16),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: AppStyles.font16WhiteSemiBold,
                  onChanged: (_) {
                    if (errorMessage != null) {
                      setDialogState(() => errorMessage = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Genre name...",
                    hintStyle: AppStyles.font14White70,
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    errorText: errorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryTeal, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text("Cancel", style: AppStyles.font14Gray),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                onPressed: () async {
                  final newGenre = textController.text.trim();
                  if (newGenre.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a genre name");
                    return;
                  }

                  final added =
                      await CategoryManager.addCustomCategory(newGenre);
                  if (!dialogContext.mounted) return;

                  if (!added) {
                    setDialogState(() => errorMessage = "Genre already exists");
                    return;
                  }

                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;
                  _loadGenres();
                  SnackBarHelper.showSuccess(context, "Added genre '$newGenre'");
                },
                child: Text(
                  "Add Genre",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditGenreDialog(String oldName) {
    if (oldName.toLowerCase() == 'no topic') return;

    final textController = TextEditingController(text: oldName);
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
              side: BorderSide(
                color: AppColors.primaryTeal.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(CupertinoIcons.pencil,
                      color: AppColors.primaryTeal, size: 18.sp),
                ),
                horizontalSpacing(10),
                Text(
                  "Rename Genre",
                  style: AppStyles.font18BoldIndigoAccent.copyWith(
                    fontSize: 18.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update genre name. All associated flashcards will be updated automatically.",
                  style: AppStyles.font14White70.copyWith(fontSize: 13.sp),
                ),
                verticalSpacing(16),
                TextField(
                  controller: textController,
                  autofocus: true,
                  style: AppStyles.font16WhiteSemiBold,
                  onChanged: (_) {
                    if (errorMessage != null) {
                      setDialogState(() => errorMessage = null);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "New genre name...",
                    hintStyle: AppStyles.font14White70,
                    filled: true,
                    fillColor: AppColors.cardSurface,
                    errorText: errorMessage,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                          color: AppColors.primaryTeal, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text("Cancel", style: AppStyles.font14Gray),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                onPressed: () async {
                  final newName = textController.text.trim();
                  if (newName.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a genre name");
                    return;
                  }

                  final success =
                      await CategoryManager.renameCategory(oldName, newName);
                  if (!dialogContext.mounted) return;

                  if (!success) {
                    setDialogState(() => errorMessage = "Genre already exists");
                    return;
                  }

                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;
                  _loadGenres();
                  SnackBarHelper.showSuccess(
                      context, "Renamed genre to '$newName'");
                },
                child: Text(
                  "Save",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteGenre(String genre) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: AppColors.errorRed.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        title: Text(
          "Delete Genre?",
          style: AppStyles.font18BoldIndigoAccent.copyWith(
            color: AppColors.white,
          ),
        ),
        content: Text(
          "All flashcards in '$genre' will be moved to 'No Topic'.",
          style: AppStyles.font14White70,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel", style: AppStyles.font14Gray),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Delete", style: AppStyles.font14WhiteSemiBold),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await CategoryManager.deleteCategoryAndReassignCards(genre);
      if (!mounted) return;
      _loadGenres();
      SnackBarHelper.showInfo(
          context, "Deleted '$genre' (cards moved to No Topic)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.review,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.chevron_left,
                color: AppColors.indigoAccent),
            onPressed: () => context.pop(),
          ),
          title: Text(
            "Genres",
            style: AppStyles.font18BoldIndigoAccent,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                ),
                onPressed: _showAddGenreDialog,
                icon: Icon(CupertinoIcons.add,
                    color: AppColors.darkBackground, size: 16.sp),
                label: Text(
                  "Add",
                  style: AppStyles.font16WhiteSemiBold.copyWith(
                    color: AppColors.darkBackground,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header info row
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primaryTeal.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.tag_fill,
                          color: AppColors.primaryTeal, size: 18.sp),
                      horizontalSpacing(10),
                      Expanded(
                        child: Text(
                          "${_genres.length} genres available",
                          style: AppStyles.font14LavenderGrayMedium.copyWith(
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      Text(
                        "Swipe to delete",
                        style: AppStyles.font11GrayRegular.copyWith(
                          color: AppColors.lavenderGray.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpacing(16),
                Expanded(
                  child: _genres.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.tag,
                                color: AppColors.lavenderGray
                                    .withValues(alpha: 0.3),
                                size: 64.sp,
                              ),
                              verticalSpacing(16),
                              Text(
                                "No genres yet",
                                style: AppStyles.font18WhiteBold.copyWith(
                                  color: AppColors.lavenderGray
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              verticalSpacing(8),
                              Text(
                                "Tap 'Add' to create your first genre",
                                style: AppStyles.font14White70,
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _genres.length,
                          separatorBuilder: (context, _) => verticalSpacing(10),
                          itemBuilder: (context, index) {
                            final genre = _genres[index];
                            final isDefault =
                                genre.toLowerCase() == 'no topic';
                            final color = AppColors.categoryColors[genre] ??
                                AppColors.primaryTeal;

                            return Dismissible(
                              key: Key('genre_$genre'),
                              direction: isDefault
                                  ? DismissDirection.none
                                  : DismissDirection.endToStart,
                              confirmDismiss: isDefault
                                  ? null
                                  : (_) async {
                                      await _deleteGenre(genre);
                                      return false; // Handle deletion ourselves
                                    },
                              background: Container(
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.errorRed.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border:
                                      Border.all(color: AppColors.errorRed),
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 24.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Delete",
                                      style: AppStyles.font14WhiteSemiBold
                                          .copyWith(color: AppColors.errorRed),
                                    ),
                                    horizontalSpacing(8),
                                    Icon(CupertinoIcons.trash,
                                        color: AppColors.errorRed, size: 20.sp),
                                  ],
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: AppColors.cardSurface,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: color.withValues(alpha: 0.3),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12.w,
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    horizontalSpacing(12),
                                    Expanded(
                                      child: Text(
                                        genre,
                                        style:
                                            AppStyles.font18WhiteMedium.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (!isDefault) ...[
                                      IconButton(
                                        icon: Icon(CupertinoIcons.pencil,
                                            color: AppColors.primaryTeal,
                                            size: 18.sp),
                                        onPressed: () =>
                                            _showEditGenreDialog(genre),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.all(4.w),
                                      ),
                                      horizontalSpacing(8),
                                      IconButton(
                                        icon: Icon(CupertinoIcons.trash,
                                            color: AppColors.errorRed,
                                            size: 18.sp),
                                        onPressed: () => _deleteGenre(genre),
                                        constraints: const BoxConstraints(),
                                        padding: EdgeInsets.all(4.w),
                                      ),
                                    ] else ...[
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 4.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.white
                                              .withValues(alpha: 0.08),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          "Default",
                                          style: AppStyles.font11GrayRegular
                                              .copyWith(
                                            color: AppColors.lavenderGray,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
