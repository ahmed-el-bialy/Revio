import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../cards/data/models/card_model.dart';

class StudyFlashCard extends StatelessWidget {
  final CardModel card;
  final GlobalKey<FlipCardState> flipKey;

  const StudyFlashCard({
    super.key,
    required this.card,
    required this.flipKey,
  });

  bool _isArabic(String text) => RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 40.w;
    final isFrontArabic = _isArabic(card.front);
    final isBackArabic = _isArabic(card.back);
    final hasHint = card.hint != null && card.hint!.trim().isNotEmpty;
    final hintText = card.hint ?? '';
    final isHintArabic = hasHint && _isArabic(hintText);

    return FlipCard(
      key: flipKey,
      direction: FlipDirection.HORIZONTAL,
      speed: 350,
      front: _CardFace(
        width: cardWidth,
        label: 'QUESTION',
        labelColor: AppColors.primaryCyan,
        content: card.front,
        isArabic: isFrontArabic,
        footer: hasHint
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryCyan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryCyan.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.lightbulb_fill,
                          color: AppColors.primaryCyan,
                          size: 14.sp,
                        ),
                        horizontalSpacing(6),
                        Text(
                          'Hint',
                          style: AppStyles.font12LavenderGrayFaded.copyWith(
                            color: AppColors.primaryCyan,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    verticalSpacing(4),
                    Directionality(
                      textDirection:
                          isHintArabic ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(
                        hintText,
                        style: AppStyles.font12LavenderGrayFaded.copyWith(
                          color: AppColors.white.withValues(alpha: 0.90),
                          fontStyle: FontStyle.italic,
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                        textAlign:
                            isHintArabic ? TextAlign.right : TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
      back: _CardFace(
        width: cardWidth,
        label: 'ANSWER',
        labelColor: AppColors.emeraldGold,
        content: card.back,
        isArabic: isBackArabic,
        isFront: false,
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final double width;
  final String label;
  final Color labelColor;
  final String content;
  final bool isArabic;
  final bool isFront;
  final Widget? footer;
  final String? topBadge;

  const _CardFace({
    required this.width,
    required this.label,
    required this.labelColor,
    required this.content,
    required this.isArabic,
    this.isFront = true,
    this.footer,
    this.topBadge,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: 24,
      borderColor: labelColor.withValues(alpha: 0.3),
      padding: EdgeInsets.all(24.w),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (topBadge != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: labelColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      topBadge!,
                      style: AppStyles.font11GrayRegular.copyWith(
                        color: labelColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: labelColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    label,
                    style: AppStyles.font11GrayRegular.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpacing(24),
            Expanded(
              child: Center(
                child: Directionality(
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      content,
                      textAlign:
                          isArabic ? TextAlign.right : TextAlign.center,
                      style: AppStyles.font18WhiteBold.copyWith(
                        fontSize: 20.sp,
                        fontWeight:
                            isFront ? FontWeight.w700 : FontWeight.w600,
                        color: isFront ? AppColors.white : AppColors.iceBlue,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (footer != null) ...[
              verticalSpacing(16),
              footer!,
            ],
            verticalSpacing(12),
            Text(
              isFront ? 'Tap to reveal answer' : 'Tap to see question',
              style: AppStyles.font12LavenderGrayFaded.copyWith(
                color: AppColors.lavenderGray.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
