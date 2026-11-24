import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';

class DeleteGenreDialog {
  static Future<bool> show(BuildContext context, {required String genre}) {
    return AppConfirmDialog.show(
      context,
      title: 'Delete Topic?',
      message: "All flashcards in '$genre' will be moved to 'No Topic'.",
      confirmLabel: 'Delete',
      icon: CupertinoIcons.trash_fill,
      isDestructive: true,
    );
  }
}
