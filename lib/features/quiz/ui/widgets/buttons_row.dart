import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cards/data/models/card_model.dart';

class ButtonsRow extends StatelessWidget {
  const ButtonsRow({
    super.key,
    required this._currentPage,
    required this._pageController,
    required this.cards,
  });

  final int _currentPage;
  final PageController _pageController;
  final List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentPage > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(CupertinoIcons.left_chevron),
            label: const Text("Previous"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oceanBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentPage < cards.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(CupertinoIcons.right_chevron),
            label: const Text("Next"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigoAccent,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
