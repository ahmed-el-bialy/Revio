import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../quiz_results_screen.dart';
import 'quiz_result_stat_row.dart';

class QuizResultsStatsCard extends StatelessWidget {
  final QuizResultsArguments args;
  final String formattedTime;

  const QuizResultsStatsCard({
    super.key,
    required this.args,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 22,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Column(
        children: [
          QuizResultStatRow(
            icon: CupertinoIcons.check_mark_circled_solid,
            color: AppColors.successGreen,
            label: "Correct Answers",
            value: args.correctCount.toString(),
          ),
          _buildDivider(),
          QuizResultStatRow(
            icon: CupertinoIcons.xmark_circle_fill,
            color: AppColors.errorRed,
            label: "Wrong Answers",
            value: args.wrongCount.toString(),
          ),
          _buildDivider(),
          QuizResultStatRow(
            icon: CupertinoIcons.forward_fill,
            color: AppColors.primaryCyan,
            label: "Skipped Cards",
            value: args.skippedCount.toString(),
          ),
          _buildDivider(),
          QuizResultStatRow(
            icon: CupertinoIcons.stopwatch_fill,
            color: AppColors.indigoAccent,
            label: "Time Taken",
            value: formattedTime,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Container(
        height: 1,
        color: AppColors.white.withValues(alpha: 0.08),
      ),
    );
  }
}
