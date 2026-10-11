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
import 'widgets/add_genre_dialog.dart';
import 'widgets/delete_genre_dialog.dart';
import 'widgets/genre_card_item.dart';
import 'widgets/rename_genre_dialog.dart';

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

  Future<void> _deleteGenre(String genre) async {
    final confirm = await DeleteGenreDialog.show(context, genre: genre);
    if (confirm == true && mounted) {
      await CategoryManager.deleteCategoryAndReassignCards(genre);
      if (!mounted) return;
      _loadGenres();
      SnackBarHelper.showInfo(
        context,
        "Deleted '$genre' (cards moved to No Topic)",
      );
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
            icon: const Icon(
              CupertinoIcons.chevron_left,
              color: AppColors.indigoAccent,
            ),
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
                onPressed: () => AddGenreDialog.show(
                  context,
                  onGenreAdded: _loadGenres,
                ),
                icon: Icon(
                  CupertinoIcons.add,
                  color: AppColors.darkBackground,
                  size: 16.sp,
                ),
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
                      Icon(
                        CupertinoIcons.tag_fill,
                        color: AppColors.primaryTeal,
                        size: 18.sp,
                      ),
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
                                      return false;
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
                                    Icon(
                                      CupertinoIcons.trash,
                                      color: AppColors.errorRed,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                              child: GenreCardItem(
                                genre: genre,
                                isDefault: isDefault,
                                color: color,
                                onEdit: () => RenameGenreDialog.show(
                                  context,
                                  oldName: genre,
                                  onGenreRenamed: _loadGenres,
                                ),
                                onDelete: () => _deleteGenre(genre),
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
