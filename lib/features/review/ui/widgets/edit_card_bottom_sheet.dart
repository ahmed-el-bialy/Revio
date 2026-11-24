import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../cards/data/models/card_model.dart';
import 'flashcard_form_fields.dart';

class EditCardBottomSheet extends StatefulWidget {
  final CardModel cardModel;
  final Function(CardModel updatedCard) onCardUpdated;
  final VoidCallback? onDeleteCard;

  const EditCardBottomSheet({
    super.key,
    required this.cardModel,
    required this.onCardUpdated,
    this.onDeleteCard,
  });

  @override
  State<EditCardBottomSheet> createState() => _EditCardBottomSheetState();
}

class _EditCardBottomSheetState extends State<EditCardBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _hintController;
  late final TextEditingController _answerController;
  late String _selectedCategory;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.cardModel.front);
    _hintController = TextEditingController(text: widget.cardModel.hint ?? '');
    _answerController = TextEditingController(text: widget.cardModel.back);
    _selectedCategory = widget.cardModel.category ?? AppConstants.defaultTopic;
    _isFavorite = widget.cardModel.isFavorite ?? false;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    widget.onCardUpdated(
      CardModel(
        id: widget.cardModel.id,
        category: _selectedCategory,
        front: _questionController.text.trim(),
        hint: _hintController.text.trim().isEmpty
            ? null
            : _hintController.text.trim(),
        back: _answerController.text.trim(),
        isFavorite: _isFavorite,
        difficulty: widget.cardModel.difficulty,
        createdAt: widget.cardModel.createdAt,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppSheetFrame(
      title: 'Edit flashcard',
      icon: CupertinoIcons.pencil,
      actions: [
        Row(
          children: [
            if (widget.onDeleteCard != null) ...[
              Expanded(
                child: AppButton.danger(
                  label: 'Delete',
                  icon: CupertinoIcons.trash,
                  onPressed: () {
                    widget.onDeleteCard!();
                    context.pop();
                  },
                ),
              ),
              horizontalSpacing(12),
            ],
            Expanded(
              flex: 2,
              child: AppButton.primary(
                label: 'Save changes',
                onPressed: _save,
              ),
            ),
          ],
        ),
      ],
      child: Form(
        key: _formKey,
        child: FlashcardFormFields(
          questionController: _questionController,
          hintController: _hintController,
          answerController: _answerController,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() => _selectedCategory = category);
          },
          isFavorite: _isFavorite,
          onFavoriteChanged: (fav) => setState(() => _isFavorite = fav),
        ),
      ),
    );
  }
}
