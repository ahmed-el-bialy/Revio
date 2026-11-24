import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/helpers/category_manager.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/widgets/app_text_dialog.dart';

class AddGenreDialog {
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onGenreAdded,
  }) async {
    final added = await AppTextDialog.show(
      context,
      title: 'Add New Topic',
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
    onGenreAdded();
    SnackBarHelper.showSuccess(context, "Added topic '$added'");
  }
}
