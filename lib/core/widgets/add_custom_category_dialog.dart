import 'package:cupertino_ui/cupertino_ui.dart';

import '../helpers/category_manager.dart';
import '../helpers/snackbar_helper.dart';
import 'app_text_dialog.dart';

class AddCustomCategoryDialog {
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onCategoryAdded,
  }) async {
    final added = await AppTextDialog.show(
      context,
      title: 'Add Custom Topic',
      subtitle: 'Create a new topic category for your flashcards.',
      hint: 'Topic name...',
      confirmLabel: 'Add',
      icon: CupertinoIcons.tag_fill,
      onSubmit: (value) async {
        final created = await CategoryManager.addCustomCategory(value);
        if (!created) return 'Topic already exists';
        return null;
      },
    );

    if (added == null || !context.mounted) return;
    onCategoryAdded();
    SnackBarHelper.showSuccess(context, "Added topic '$added'");
  }
}
