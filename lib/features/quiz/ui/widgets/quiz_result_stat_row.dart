import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_styles.dart';

class QuizResultStatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const QuizResultStatRow({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
