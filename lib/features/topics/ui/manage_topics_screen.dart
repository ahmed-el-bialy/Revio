import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/category_manager.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_background_glow.dart';

class ManageTopicsScreen extends StatefulWidget {
  const ManageTopicsScreen({super.key});

  @override
  State<ManageTopicsScreen> createState() => _ManageTopicsScreenState();
}

class _ManageTopicsScreenState extends State<ManageTopicsScreen> {
  List<String> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  void _loadTopics() {
    final activeCore = CategoryManager.getActiveCoreCategories();
    final custom = CategoryManager.getCustomCategories();
    setState(() {
      _topics = [...activeCore, ...custom];
    });
  }

  void _showAddTopicDialog() {
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
                  "Add New Topic",
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
                  "Create a new topic category for your flashcards.",
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
                    hintText: "Topic name...",
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                onPressed: () async {
                  final newCat = textController.text.trim();
                  if (newCat.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a topic name");
                    return;
                  }

                  await CategoryManager.addCustomCategory(newCat);
                  if (!dialogContext.mounted) return;
                  Navigator.of(dialogContext).pop();

                  if (!mounted) return;
                  _loadTopics();
                  SnackBarHelper.showSuccess(context, "Added topic '$newCat'");
                },
                child: Text(
                  "Add Topic",
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

  void _showEditTopicDialog(String oldName) {
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
                  "Rename Topic",
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
                  "Update topic name. All associated flashcards will be updated automatically.",
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
                    hintText: "New topic name...",
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
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                ),
                onPressed: () async {
                  final newName = textController.text.trim();
                  if (newName.isEmpty) {
                    setDialogState(
                        () => errorMessage = "Please enter a topic name");
                    return;
                  }

                  final success =
                      await CategoryManager.renameCategory(oldName, newName);
                  if (!dialogContext.mounted) return;

                  if (!success) {
                    setDialogState(() => errorMessage = "Topic already exists");
                    return;
                  }

                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;
                  _loadTopics();
                  SnackBarHelper.showSuccess(
                      context, "Renamed topic to '$newName'");
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
          title: Text(
            "Manage Topics & Genres",
            style: AppStyles.font18BoldIndigoAccent,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.indigoAccent),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Topics (${_topics.length})",
                      style: AppStyles.font17BoldIceBlue.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 10.h),
                      ),
                      onPressed: _showAddTopicDialog,
                      icon: Icon(CupertinoIcons.add,
                          color: AppColors.darkBackground, size: 16.sp),
                      label: Text(
                        "Add Topic",
                        style: AppStyles.font16WhiteSemiBold.copyWith(
                          color: AppColors.darkBackground,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpacing(16),
                Expanded(
                  child: _topics.isEmpty
                      ? Center(
                          child: Text(
                            "No topics found.",
                            style: AppStyles.font16LavenderGray,
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _topics.length,
                          separatorBuilder: (context, _) => verticalSpacing(12),
                          itemBuilder: (context, index) {
                            final topic = _topics[index];
                            final isNoTopic = topic.toLowerCase() == 'no topic';
                            final color = AppColors.categoryColors[topic] ??
                                AppColors.primaryTeal;

                            return Container(
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
                                      topic,
                                      style: AppStyles.font18WhiteMedium.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (!isNoTopic) ...[
                                    IconButton(
                                      icon: Icon(CupertinoIcons.pencil,
                                          color: AppColors.primaryTeal,
                                          size: 18.sp),
                                      onPressed: () =>
                                          _showEditTopicDialog(topic),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.all(4.w),
                                    ),
                                    horizontalSpacing(8),
                                    IconButton(
                                      icon: Icon(CupertinoIcons.trash,
                                          color: AppColors.errorRed,
                                          size: 18.sp),
                                      onPressed: () async {
                                        await CategoryManager
                                            .deleteCategoryAndReassignCards(
                                                topic);
                                        if (!context.mounted) return;
                                        _loadTopics();
                                        SnackBarHelper.showInfo(context,
                                            "Deleted '$topic' (cards moved to No Topic)");
                                      },
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
                                        borderRadius: BorderRadius.circular(8.r),
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
