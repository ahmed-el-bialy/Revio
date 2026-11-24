import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helpers/routing_extension.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../cards/data/models/card_model.dart';
import '../../../cards/data/repo/cards_repo.dart';
import 'flashcard_form_fields.dart';

class AddCardModalBottomSheet extends StatefulWidget {
  final String? initialCategory;

  const AddCardModalBottomSheet({super.key, this.initialCategory});

  @override
  State<AddCardModalBottomSheet> createState() =>
      _AddCardModalBottomSheetState();
}

class _AddCardModalBottomSheetState extends State<AddCardModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  late String _selectedCategory;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.initialCategory != null && widget.initialCategory != 'All'
        ? widget.initialCategory!
        : AppConstants.categories.first;
  }

  @override
  void dispose() {
    _questionController.dispose();
    _hintController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newCard = CardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _selectedCategory,
      front: _questionController.text.trim(),
      hint: _hintController.text.trim().isEmpty
          ? null
          : _hintController.text.trim(),
      back: _answerController.text.trim(),
      isFavorite: false,
      createdAt: DateTime.now(),
    );

    try {
      await CardsRepo().saveCard(newCard);
      if (!mounted) return;
      context.pop();
      SnackBarHelper.showSuccess(context, 'Flashcard added successfully');
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      SnackBarHelper.showError(context, 'Could not save this flashcard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppSheetFrame(
      title: 'Add flashcard',
      icon: CupertinoIcons.add,
      actions: [
        AppButton.primary(
          label: 'Save card',
          icon: CupertinoIcons.checkmark_alt,
          loading: _isSaving,
          onPressed: _isSaving ? null : _saveCard,
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
        ),
      ),
    );
  }
}
