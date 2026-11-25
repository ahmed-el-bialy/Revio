import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../data/models/quiz_result_model.dart';
import '../data/repo/quiz_history_repo.dart';

class QuizHistoryScreen extends StatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  State<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends State<QuizHistoryScreen> {
  List<QuizResultModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = QuizHistoryRepo().getAllResults();
    });
  }

  Future<void> _deleteEntry(String id) async {
    final confirm = await AppConfirmDialog.show(
      context,
      title: "Delete Result?",
      message: "This quiz result will be removed from history.",
      confirmLabel: "Delete",
      icon: CupertinoIcons.trash_fill,
      isDestructive: true,
    );
    if (confirm == true) {
      await QuizHistoryRepo().deleteResult(id);
      _loadHistory();
    }
  }

  Future<void> _clearAll() async {
    final confirm = await AppConfirmDialog.show(
      context,
      title: "Clear All History?",
      message: "All saved quiz history records will be permanently deleted.",
      confirmLabel: "Clear All",
      icon: CupertinoIcons.trash_fill,
      isDestructive: true,
    );
    if (confirm == true) {
      await QuizHistoryRepo().clearAll();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalQuizzes = _history.length;
    final double avgAccuracy = totalQuizzes > 0
        ? _history.fold<double>(0, (sum, r) => sum + r.scorePercentage) /
            totalQuizzes
        : 0.0;

    return AppBackgroundGlow(
      variant: GlowVariant.quiz,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.chevron_left,
              color: AppColors.primaryCyan,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text("Quiz History", style: AppStyles.font18BoldIndigoAccent),
          centerTitle: true,
          actions: [
            if (_history.isNotEmpty)
              IconButton(
                icon: const Icon(
                  CupertinoIcons.trash,
                  color: AppColors.errorRed,
                ),
                onPressed: _clearAll,
                tooltip: "Clear All History",
              ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    verticalSpacing(10),
                    // Summary Card
                    AppCard(
                      borderRadius: 20,
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem("Quizzes", "$totalQuizzes"),
                          Container(
                            width: 1.w,
                            height: 36.h,
                            color: AppColors.white.withValues(alpha: 0.1),
                          ),
                          _buildStatItem(
                            "Avg. Score",
                            "${avgAccuracy.toStringAsFixed(0)}%",
                          ),
                        ],
                      ),
                    ),
                    verticalSpacing(16),
                    Expanded(
                      child: _history.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.clock,
                                    size: 56.sp,
                                    color: AppColors.lavenderGray
                                        .withValues(alpha: 0.3),
                                  ),
                                  verticalSpacing(16),
                                  Text(
                                    "No Quiz History",
                                    style: AppStyles.font18WhiteBold,
                                  ),
                                  verticalSpacing(6),
                                  Text(
                                    "Complete a quiz to see your results here.",
                                    style: AppStyles.font14White70,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: _history.length,
                              separatorBuilder: (_, _) => verticalSpacing(10),
                              itemBuilder: (context, index) {
                                final result = _history[index];
                                final score = result.scorePercentage;
                                final dateStr =
                                    "${result.timestamp.day}/${result.timestamp.month}/${result.timestamp.year}";

                                return AppCard(
                                  borderRadius: 16,
                                  padding: EdgeInsets.all(14.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10.w),
                                        decoration: BoxDecoration(
                                          color: (score >= 70
                                                  ? AppColors.success
                                                  : AppColors.primaryCyan)
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          "${score.toStringAsFixed(0)}%",
                                          style: AppStyles.font16WhiteSemiBold
                                              .copyWith(
                                            color: score >= 70
                                                ? AppColors.success
                                                : AppColors.primaryCyan,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      horizontalSpacing(14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              result.modeName,
                                              style: AppStyles
                                                  .font16WhiteSemiBold
                                                  .copyWith(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            verticalSpacing(4),
                                            Text(
                                              "✓ ${result.correctCount}  ✗ ${result.wrongCount}  ·  $dateStr (${result.timeTakenSeconds}s)",
                                              style: AppStyles.font13GrayMedium
                                                  .copyWith(
                                                color: AppColors.lavenderGray,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          CupertinoIcons.trash,
                                          color: AppColors.errorRed
                                              .withValues(alpha: 0.7),
                                          size: 16.sp,
                                        ),
                                        onPressed: () =>
                                            _deleteEntry(result.id),
                                      ),
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
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppStyles.font20BoldWhite.copyWith(
            color: AppColors.primaryCyan,
            fontWeight: FontWeight.w800,
          ),
        ),
        verticalSpacing(2),
        Text(
          label,
          style: AppStyles.font12LavenderGray.copyWith(
            color: AppColors.lavenderGray,
          ),
        ),
      ],
    );
  }
}
