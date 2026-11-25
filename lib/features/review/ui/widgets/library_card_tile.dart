import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../cards/data/models/card_model.dart';
import '../../../cards/data/repo/cards_repo.dart';

class LibraryCardTile extends StatelessWidget {
  final CardModel cardModel;
  final VoidCallback onTap;

  const LibraryCardTile({
    super.key,
    required this.cardModel,
    required this.onTap,
  });

  bool _isArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final hasHint =
        cardModel.hint != null && cardModel.hint!.trim().isNotEmpty;
    final isFrontArabic = _isArabic(cardModel.front);
    final isBackArabic = _isArabic(cardModel.back);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: AppCard(
        borderRadius: 18,
        borderColor: AppColors.white.withValues(alpha: 0.08),
        padding: EdgeInsets.all(16.w),
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Favorite toggle button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => CardsRepo().toggleFavorite(cardModel.id),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: (cardModel.isFavorite ?? false)
                      ? AppColors.primaryCyan.withValues(alpha: 0.15)
                      : AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: (cardModel.isFavorite ?? false)
                        ? AppColors.primaryCyan.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                child: Icon(
                  (cardModel.isFavorite ?? false)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: (cardModel.isFavorite ?? false)
                      ? AppColors.primaryCyan
                      : AppColors.lavenderGray,
                  size: 18.sp,
                ),
              ),
            ),
            horizontalSpacing(14),
            // Card Content (Front, Back, Topic, Hint)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row (Topic & Hint)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCyan.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          cardModel.category ?? "General",
                          style: AppStyles.font11GrayRegular.copyWith(
                            color: AppColors.primaryCyan,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (hasHint) ...[
                        horizontalSpacing(6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.indigoAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.lightbulb_fill,
                                color: AppColors.indigoAccent,
                                size: 10.sp,
                              ),
                              horizontalSpacing(3),
                              Text(
                                "Hint",
                                style: AppStyles.font11GrayRegular.copyWith(
                                  color: AppColors.indigoAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  verticalSpacing(8),
                  // Question (Front)
                  Directionality(
                    textDirection: isFrontArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Text(
                      cardModel.front,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: isFrontArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: AppStyles.font16WhiteSemiBold.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  verticalSpacing(3),
                  // Answer (Back)
                  Directionality(
                    textDirection: isBackArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Text(
                      cardModel.back,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: isBackArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: AppStyles.font13GrayMedium.copyWith(
                        color: AppColors.lavenderGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            horizontalSpacing(8),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.lavenderGray.withValues(alpha: 0.4),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
