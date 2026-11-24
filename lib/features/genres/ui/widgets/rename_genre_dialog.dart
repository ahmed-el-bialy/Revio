import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/helpers/category_manager.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/widgets/app_text_dialog.dart';

class RenameGenreDialog {
  static Future<void> show(
    BuildContext context, {
    required String oldName,
    required VoidCallback onGenreRenamed,
  }) async {
    if (oldName.toLowerCase() == 'no topic') return;

    final renamed = await AppTextDialog.show(
      context,
      title: 'Rename Topic',
      subtitle:
          'Update the topic name. All associated flashcards will be updated automatically.',
      hint: 'New topic name...',
      confirmLabel: 'Save',
      icon: CupertinoIcons.pencil,
      initialValue: oldName,
      onSubmit: (value) async {
        final success = await CategoryManager.renameCategory(oldName, value);
        if (!success) return 'Topic already exists';
        return null;
      },
    );

    if (renamed == null || !context.mounted) return;
    onGenreRenamed();
    SnackBarHelper.showSuccess(context, "Renamed topic to '$renamed'");
  }
}
