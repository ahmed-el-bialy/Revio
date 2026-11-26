import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../logic/quiz_cubit.dart';
import '../../logic/quiz_state.dart';
import 'quiz_exit_dialog.dart';

class QuizAppBar extends StatelessWidget {
  final QuizInProgress state;

  const QuizAppBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isMcq = state.quizMode == QuizMode.multipleChoice;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 4.h),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Exit quiz',
              onPressed: () async {
                final confirm = await QuizExitDialog.show(context);
                if (confirm && context.mounted) {
                  context.read<QuizCubit>().emitShowTopicSelection();
                  context.pop();
                }
              },
              icon: Icon(
                CupertinoIcons.back,
                color: AppColors.lavenderGray,
                size: 22.sp,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMcq ? 'Multiple Choice' : 'Smart Typing',
                    style: AppStyles.font18BoldIndigoAccent.copyWith(
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isMcq
                        ? 'Tap the best answer'
                        : 'Type what you remember',
                    style: AppStyles.font12LavenderGrayFaded,
                  ),
                ],
              ),
            ),
            _InfoChip(isMcq: isMcq),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final bool isMcq;

  const _InfoChip({required this.isMcq});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isMcq
          ? 'Choose the matching answer. You get one try per card.'
          : 'Type the answer. Small typos and short forms are accepted.',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: AppColors.primaryCyan.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primaryCyan.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          CupertinoIcons.info_circle,
          color: AppColors.primaryCyan,
          size: 16.sp,
        ),
      ),
    );
  }
}
