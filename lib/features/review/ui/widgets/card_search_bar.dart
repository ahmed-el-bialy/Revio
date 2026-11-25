import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_styles.dart';
import '../../../../core/widgets/press_scale_widget.dart';

class CardSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;
  final VoidCallback onOpenFilter;
  final bool hasActiveFilter;

  const CardSearchBar({
    super.key,
    required this.searchController,
    required this.onChanged,
    required this.onOpenFilter,
    required this.hasActiveFilter,
  });

  @override
  State<CardSearchBar> createState() => _CardSearchBarState();
}

class _CardSearchBarState extends State<CardSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              decoration: BoxDecoration(
                color: AppColors.oceanBlue.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: _isFocused
                      ? AppColors.primaryCyan.withValues(alpha: 0.8)
                      : AppColors.primaryCyan.withValues(alpha: 0.15),
                  width: _isFocused ? 1.5 : 1.0,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AppColors.primaryCyan.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                controller: widget.searchController,
                focusNode: _focusNode,
                style: AppStyles.font14WhiteSemiBold.copyWith(
                  fontWeight: FontWeight.normal,
                ),
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  hintText: "Search cards...",
                  hintStyle: AppStyles.font14White70,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: _isFocused
                        ? AppColors.primaryCyan
                        : AppColors.lavenderGray,
                    size: 20.sp,
                  ),
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: widget.searchController.text.isNotEmpty
                        ? IconButton(
                            key: const ValueKey('clear_button'),
                            icon: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: AppColors.lavenderGray,
                              size: 18.sp,
                            ),
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onChanged('');
                            },
                          )
                        : const SizedBox.shrink(key: ValueKey('empty_suffix')),
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ),
          horizontalSpacing(8),
          PressScale(
            onTap: widget.onOpenFilter,
            scaleDown: 0.90,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.hasActiveFilter
                        ? AppColors.primaryCyan.withValues(alpha: 0.18)
                        : AppColors.cardSurface.withValues(alpha: 0.5),
                    border: Border.all(
                      color: widget.hasActiveFilter
                          ? AppColors.primaryCyan.withValues(alpha: 0.5)
                          : AppColors.white.withValues(alpha: 0.1),
                      width: 1.2,
                    ),
                    boxShadow: widget.hasActiveFilter
                        ? [
                            BoxShadow(
                              color: AppColors.primaryCyan
                                  .withValues(alpha: 0.25),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    CupertinoIcons.line_horizontal_3_decrease,
                    color: widget.hasActiveFilter
                        ? AppColors.primaryCyan
                        : AppColors.lavenderGray,
                    size: 20.sp,
                  ),
                ),
                if (widget.hasActiveFilter)
                  Positioned(
                    top: 2.h,
                    right: 2.w,
                    child: Container(
                      width: 9.w,
                      height: 9.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryCyan,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.darkBackground,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
