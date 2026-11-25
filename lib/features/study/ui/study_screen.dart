import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:material_ui/material_ui.dart';
import 'package:flip_card/flip_card.dart';

import '../../../core/helpers/routing_extension.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/theming/app_colors.dart';
import '../../../core/theming/app_styles.dart';
import '../../../core/widgets/app_background_glow.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/genre_chip_picker.dart';
import '../../cards/data/models/card_model.dart';
import '../../cards/logic/get_all_cards_cubit.dart';
import '../../cards/logic/get_all_cards_state.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';
  bool _onlyFavorites = false;
  final Map<String, GlobalKey<FlipCardState>> _flipKeys = {};

  GlobalKey<FlipCardState> _getFlipKey(String id) {
    return _flipKeys.putIfAbsent(id, () => GlobalKey<FlipCardState>());
  }

  List<CardModel> _filterCards(List<CardModel> allCards) {
    final filtered = allCards.where((card) {
      final matchesCat =
          _selectedCategory == 'All' || card.category == _selectedCategory;
      final matchesFav = !_onlyFavorites || (card.isFavorite ?? false);
      return matchesCat && matchesFav;
    }).toList();
    return filtered;
  }

  void _shuffle(List<CardModel> allFiltered) {
    setState(() {
      _currentIndex = 0;
      _flipKeys.clear();
    });
  }

  void _resetFlipKey(String id) {
    _flipKeys.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return AppBackgroundGlow(
      variant: GlowVariant.review,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.chevron_left,
              color: AppColors.primaryCyan,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text('Study Mode', style: AppStyles.font18BoldIndigoAccent),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Favorites only',
              icon: Icon(
                _onlyFavorites
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: _onlyFavorites
                    ? AppColors.primaryCyan
                    : AppColors.lavenderGray,
              ),
              onPressed: () => setState(() {
                _onlyFavorites = !_onlyFavorites;
                _currentIndex = 0;
                _flipKeys.clear();
              }),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<GetAllCardsCubit, GetAllCardsState>(
            builder: (context, state) {
              if (state is CardsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryCyan,
                  ),
                );
              }

              if (state is CardsLoadedSuccess) {
                final allFiltered = _filterCards(state.cards);

                if (allFiltered.isEmpty) {
                  return _EmptyState(onlyFavorites: _onlyFavorites);
                }

                if (_currentIndex >= allFiltered.length) {
                  _currentIndex = 0;
                }

                final currentCard = allFiltered[_currentIndex];
                final progress = (_currentIndex + 1) / allFiltered.length;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 750),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          // Category picker
                          GenreChipPicker(
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (cat) {
                              setState(() {
                                _selectedCategory = cat;
                                _currentIndex = 0;
                                _flipKeys.clear();
                              });
                            },
                          ),
                          verticalSpacing(12),

                          // Progress bar + counter row
                          _ProgressRow(
                            current: _currentIndex + 1,
                            total: allFiltered.length,
                            progress: progress,
                            onShuffle: () {
                              _shuffle(allFiltered);
                              context
                                  .read<GetAllCardsCubit>()
                                  .fetchAllCards();
                            },
                          ),
                          verticalSpacing(16),

                          // Flash card (flip to reveal)
                          Expanded(
                            child: Center(
                              child: _StudyFlashCard(
                                key: ValueKey(currentCard.id),
                                card: currentCard,
                                flipKey: _getFlipKey(currentCard.id),
                              ),
                            ),
                          ),

                          verticalSpacing(20),

                          // Navigation buttons
                          _NavigationRow(
                            onPrev: _currentIndex > 0
                                ? () {
                                    _resetFlipKey(currentCard.id);
                                    setState(() => _currentIndex--);
                                  }
                                : null,
                            onNext: _currentIndex < allFiltered.length - 1
                                ? () {
                                    _resetFlipKey(currentCard.id);
                                    setState(() => _currentIndex++);
                                  }
                                : null,
                            isLast:
                                _currentIndex == allFiltered.length - 1,
                          ),
                          verticalSpacing(24),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// ── Progress Row ────────────────────────────────────────────────────────────

class _ProgressRow extends StatelessWidget {
  final int current;
  final int total;
  final double progress;
  final VoidCallback onShuffle;

  const _ProgressRow({
    required this.current,
    required this.total,
    required this.progress,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Card $current of $total',
                style: AppStyles.font13GrayMedium.copyWith(
                  color: AppColors.primaryCyan,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Tap card to flip 🔄',
              style: AppStyles.font12LavenderGrayFaded,
            ),
            horizontalSpacing(12),
            GestureDetector(
              onTap: onShuffle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.indigoAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.indigoAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.shuffle,
                      color: AppColors.indigoAccent,
                      size: 13.sp,
                    ),
                    horizontalSpacing(4),
                    Text(
                      'Shuffle',
                      style: AppStyles.font12LavenderGrayFaded.copyWith(
                        color: AppColors.indigoAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        verticalSpacing(10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4.h,
            backgroundColor: AppColors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryCyan,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Flash Card Widget ────────────────────────────────────────────────────────

class _StudyFlashCard extends StatelessWidget {
  final CardModel card;
  final GlobalKey<FlipCardState> flipKey;

  const _StudyFlashCard({
    super.key,
    required this.card,
    required this.flipKey,
  });

  bool _isArabic(String text) =>
      RegExp(r'[\u0600-\u06FF]').hasMatch(text);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width - 40.w;
    final isFrontArabic = _isArabic(card.front);
    final isBackArabic = _isArabic(card.back);
    final hasHint = card.hint != null && card.hint!.trim().isNotEmpty;

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
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.lightbulb_fill,
                    color: AppColors.softAmber,
                    size: 13.sp,
                  ),
                  horizontalSpacing(5),
                  Text(
                    card.hint!,
                    style: AppStyles.font12LavenderGrayFaded.copyWith(
                      color: AppColors.softAmber.withValues(alpha: 0.85),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : null,
        topBadge: card.category != null && card.category!.isNotEmpty
            ? card.category!
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
            // Top row: badge + label
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

            // Content
            Expanded(
              child: Center(
                child: Directionality(
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      content,
                      textAlign: isArabic ? TextAlign.right : TextAlign.center,
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

// ── Navigation Row ───────────────────────────────────────────────────────────

class _NavigationRow extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final bool isLast;

  const _NavigationRow({
    required this.onPrev,
    required this.onNext,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _NavButton(
            label: 'Previous',
            icon: CupertinoIcons.chevron_left,
            isEnabled: onPrev != null,
            onTap: onPrev,
            isPrimary: false,
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          child: _NavButton(
            label: isLast ? 'Finish 🎉' : 'Next',
            icon: isLast ? CupertinoIcons.checkmark_alt : CupertinoIcons.chevron_right,
            isEnabled: onNext != null || isLast,
            onTap: isLast ? () => context.pop() : onNext,
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isEnabled;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? AppColors.primaryCyan : AppColors.indigoAccent;
    final effectiveColor = isEnabled ? color : AppColors.lavenderGray.withValues(alpha: 0.3);

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: isPrimary ? 1 : 0.1)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: effectiveColor.withValues(alpha: isPrimary ? 0 : 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isPrimary) ...[
              Icon(
                icon,
                size: 16.sp,
                color: isEnabled
                    ? (isPrimary ? AppColors.darkBackground : color)
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
              horizontalSpacing(6),
            ],
            Text(
              label,
              style: AppStyles.font16WhiteSemiBold.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isEnabled
                    ? (isPrimary ? AppColors.darkBackground : color)
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
            ),
            if (isPrimary) ...[
              horizontalSpacing(6),
              Icon(
                icon,
                size: 16.sp,
                color: isEnabled
                    ? AppColors.darkBackground
                    : AppColors.lavenderGray.withValues(alpha: 0.3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool onlyFavorites;

  const _EmptyState({required this.onlyFavorites});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              onlyFavorites
                  ? CupertinoIcons.heart_slash
                  : CupertinoIcons.rectangle_stack_badge_minus,
              size: 64.sp,
              color: AppColors.lavenderGray.withValues(alpha: 0.3),
            ),
            verticalSpacing(20),
            Text(
              onlyFavorites ? 'No Favorite Cards' : 'No Cards Yet',
              style: AppStyles.font18WhiteBold,
              textAlign: TextAlign.center,
            ),
            verticalSpacing(8),
            Text(
              onlyFavorites
                  ? 'Mark some cards as favorites to study them here.'
                  : 'Add flashcards to start studying.',
              style: AppStyles.font14White70,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
