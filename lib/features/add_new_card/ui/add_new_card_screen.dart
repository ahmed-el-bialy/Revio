import 'package:cupertino_ui/cupertino_ui.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/genre_chip_picker.dart';
import 'widgets/app_text_form.dart';
import 'widgets/appbar_body.dart';
import 'widgets/card_form_back_scope.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _hintController = TextEditingController();
  final _answerController = TextEditingController();
  String _selectedCategory = AppConstants.defaultTopic;
  bool _isFavorite = false;

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CardFormBackScope(
      questionController: _questionController,
      hintController: _hintController,
      answerController: _answerController,
      child: AppBackgroundGlow(
        variant: GlowVariant.addCard,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 750),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Form(
                        key: _formKey,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: AppbarBody(
                                questionController: _questionController,
                                hintController: _hintController,
                                answerController: _answerController,
                                selectedCategory: _selectedCategory,
                                formKey: _formKey,
                                isFavorite: _isFavorite,
                              ),
                            ),
                            sliverVerticalSpacing(20),
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _SectionLabel(
                                    label: "Topic / Category",
                                  ),
                                  verticalSpacing(10),
                                  GenreChipPicker(
                                    selectedCategory: _selectedCategory,
                                    onCategorySelected: (cat) => setState(
                                      () => _selectedCategory = cat,
                                    ),
                                  ),
                                  verticalSpacing(24),
                                  const _SectionLabel(
                                    label: "Question (Front)",
                                  ),
                                  verticalSpacing(10),
                                  AppTextForm(
                                    controller: _questionController,
                                    hint: "What do you want to remember?",
                                    maxLines: 3,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Please enter a question';
                                      }
                                      return null;
                                    },
                                  ),
                                  verticalSpacing(20),
                                  const _SectionLabel(
                                    label: "Hint",
                                    badge: "Optional",
                                  ),
                                  verticalSpacing(10),
                                  AppTextForm(
                                    controller: _hintController,
                                    maxLines: 2,
                                    hint: "A small clue to help recall...",
                                  ),
                                  verticalSpacing(20),
                                  const _SectionLabel(label: "Answer (Back)"),
                                  verticalSpacing(10),
                                  AppTextForm(
                                    controller: _answerController,
                                    maxLines: 4,
                                    hint: "The answer or explanation...",
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Please enter an answer';
                                      }
                                      return null;
                                    },
                                  ),
                                  verticalSpacing(24),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(
                                      () => _isFavorite = !_isFavorite,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceDark,
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: _isFavorite
                                              ? AppColors.primaryCyan
                                              : AppColors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                          width: _isFavorite ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: _isFavorite
                                                  ? AppColors.primaryCyan
                                                      .withValues(alpha: 0.15)
                                                  : AppColors.cardSurface,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              _isFavorite
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: _isFavorite
                                                  ? AppColors.primaryCyan
                                                  : AppColors.lavenderGray,
                                              size: 18.sp,
                                            ),
                                          ),
                                          horizontalSpacing(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Mark as Favorite",
                                                  style: AppStyles
                                                      .font16WhiteSemiBold
                                                      .copyWith(
                                                    fontSize: 15.sp,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                                verticalSpacing(2),
                                                Text(
                                                  "Add this card to your favorites list instantly",
                                                  style: AppStyles
                                                      .font13GrayMedium
                                                      .copyWith(
                                                    color: AppColors
                                                        .lavenderGray,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CupertinoSwitch(
                                            value: _isFavorite,
                                            activeTrackColor: AppColors.primaryCyan,
                                            onChanged: (fav) => setState(
                                              () => _isFavorite = fav,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  verticalSpacing(40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final String? badge;

  const _SectionLabel({required this.label, this.badge});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppStyles.font16LavenderGray.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.lavenderGray,
          ),
        ),
        if (badge != null) ...[
          horizontalSpacing(8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: AppColors.primaryTeal.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              badge!,
              style: AppStyles.font11GrayRegular.copyWith(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
