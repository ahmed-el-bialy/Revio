import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_glass_container.dart';
import '../../../core/widgets/press_scale_widget.dart';
import 'widgets/quiz_result_stat_row.dart';
import 'widgets/score_ring_painter.dart';

class QuizResultsArguments {
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final int totalCards;
  final Duration timeTaken;

  const QuizResultsArguments({
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.totalCards,
    required this.timeTaken,
  });

  double get scorePercentage =>
      totalCards > 0 ? (correctCount / totalCards) * 100 : 0;
}

class QuizResultsScreen extends StatefulWidget {
  final QuizResultsArguments args;

  const QuizResultsScreen({super.key, required this.args});

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _statsEntranceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.args.scorePercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _statsEntranceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getPerformanceMessage() {
    final score = widget.args.scorePercentage;
    if (score == 100) return "🏆 Outstanding Master!";
    if (score >= 80) return "🌟 Impressive Knowledge!";
    if (score >= 50) return "👍 Great Effort!";
    return "💪 Keep Practicing!";
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 50) return AppColors.softAmber;
    return AppColors.errorRed;
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor(widget.args.scorePercentage);

    return AppBackgroundGlow(
      variant: GlowVariant.quiz,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalSpacing(10),
              Text(
                "Quiz Completed",
                style: AppStyles.font28BoldIceBlue.copyWith(
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              verticalSpacing(6),
              Text(
                "Here is how you performed",
                style: AppStyles.font14White70,
                textAlign: TextAlign.center,
              ),
              verticalSpacing(30),

              // Animated score ring
              Center(
                child: SizedBox(
                  width: 200.w,
                  height: 200.w,
                  child: AnimatedBuilder(
                    animation: _scoreAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ScoreRingPainter(
                          score: _scoreAnimation.value,
                          color: scoreColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${_scoreAnimation.value.toInt()}%",
                                style: AppStyles.font40BoldWhite.copyWith(
                                  letterSpacing: -1,
                                ),
                              ),
                              verticalSpacing(6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: scoreColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: scoreColor.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _getPerformanceMessage(),
                                  style: AppStyles.font13GrayMedium.copyWith(
                                    color: scoreColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              verticalSpacing(36),

              // Glass card for stats breakdown
              AnimatedBuilder(
                animation: _statsEntranceAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _statsEntranceAnimation.value,
                    child: Transform.translate(
                      offset: Offset(
                          0, 20 * (1.0 - _statsEntranceAnimation.value)),
                      child: child,
                    ),
                  );
                },
                child: AppGlassContainer(
                  borderRadius: 24,
                  borderOpacity: 0.35,
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
                        value: widget.args.correctCount.toString(),
                      ),
                      _buildDivider(),
                      QuizResultStatRow(
                        icon: CupertinoIcons.xmark_circle_fill,
                        color: AppColors.errorRed,
                        label: "Wrong Answers",
                        value: widget.args.wrongCount.toString(),
                      ),
                      _buildDivider(),
                      QuizResultStatRow(
                        icon: CupertinoIcons.forward_fill,
                        color: AppColors.softAmber,
                        label: "Skipped Cards",
                        value: widget.args.skippedCount.toString(),
                      ),
                      _buildDivider(),
                      QuizResultStatRow(
                        icon: CupertinoIcons.stopwatch_fill,
                        color: AppColors.primaryCyan,
                        label: "Time Taken",
                        value: _formatTime(widget.args.timeTaken),
                      ),
                    ],
                  ),
                ),
              ),

              verticalSpacing(36),

              // Play Again glass/cyber button
              PressScale(
                onTap: () => context.pop(true),
                scaleDown: 0.97,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCyan.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.arrow_counterclockwise,
                          color: AppColors.darkBackground,
                          size: 18.sp,
                        ),
                        horizontalSpacing(8),
                        Text(
                          "Play Again",
                          style: AppStyles.font16WhiteSemiBold.copyWith(
                            color: AppColors.darkBackground,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              verticalSpacing(12),

              // Back to modes button
              PressScale(
                onTap: () => context.pop(false),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Center(
                    child: Text(
                      "Back to Modes",
                      style: AppStyles.font15IndigoAccentSemiBold.copyWith(
                        color: AppColors.lavenderGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpacing(20),
            ],
          ),
        ),
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
