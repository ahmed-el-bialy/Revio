import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/helpers/spacing.dart';

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

  double get scorePercentage => totalCards > 0 ? (correctCount / totalCards) * 100 : 0;
}

class QuizResultsScreen extends StatefulWidget {
  final QuizResultsArguments args;

  const QuizResultsScreen({super.key, required this.args});

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.args.scorePercentage,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    if (score == 100) return "Perfect!";
    if (score >= 80) return "Great job!";
    if (score >= 50) return "Good effort!";
    return "Keep practicing!";
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Quiz Completed",
                style: AppStyles.font28BoldIceBlue,
                textAlign: TextAlign.center,
              ),
              verticalSpacing(40),
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
                          color: _getScoreColor(widget.args.scorePercentage),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${_scoreAnimation.value.toInt()}%",
                                style: AppStyles.font40BoldWhite,
                              ),
                              verticalSpacing(8),
                              Text(
                                _getPerformanceMessage(),
                                style: AppStyles.font16LavenderGray,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              verticalSpacing(40),
              _buildStatRow(
                icon: Icons.check_circle_outline,
                color: AppColors.successGreen,
                label: "Correct",
                value: widget.args.correctCount.toString(),
              ),
              verticalSpacing(16),
              _buildStatRow(
                icon: Icons.cancel_outlined,
                color: AppColors.errorRed,
                label: "Wrong",
                value: widget.args.wrongCount.toString(),
              ),
              verticalSpacing(16),
              _buildStatRow(
                icon: Icons.skip_next_outlined,
                color: AppColors.softAmber,
                label: "Skipped",
                value: widget.args.skippedCount.toString(),
              ),
              verticalSpacing(16),
              _buildStatRow(
                icon: Icons.timer_outlined,
                color: AppColors.indigoAccent,
                label: "Time",
                value: _formatTime(widget.args.timeTaken),
              ),
              verticalSpacing(48),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true), // Play again -> returns true
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.indigoAccent,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Play Again",
                  style: AppStyles.font16WhiteSemiBold,
                ),
              ),
              verticalSpacing(16),
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Back to home -> returns false
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  "Back to Home",
                  style: AppStyles.font15IndigoAccentSemiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return AppColors.successGreen;
    if (score >= 50) return AppColors.softAmber;
    return AppColors.errorRed;
  }

  Widget _buildStatRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24.w),
        horizontalSpacing(12),
        Text(
          label,
          style: AppStyles.font16LavenderGray,
        ),
        const Spacer(),
        Text(
          value,
          style: AppStyles.font18WhiteBold,
        ),
      ],
    );
  }
}

class ScoreRingPainter extends CustomPainter {
  final double score;
  final Color color;

  ScoreRingPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = 16.w;

    final backgroundPaint = Paint()
      ..color = AppColors.surfaceDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final scorePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    final sweepAngle = 2 * pi * (score / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScoreRingPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
