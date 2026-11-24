import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';

class DeleteGenreDialog {
  static Future<bool> show(
    BuildContext context, {
    required String genre,
    int cardCount = 0,
  }) {
    final cardText = cardCount == 1 ? '1 flashcard' : '$cardCount flashcards';
    final message = cardCount > 0
        ? "Deleting '$genre' will move $cardText to 'No Topic'."
        : "Deleting '$genre' will not affect any existing flashcards.";

    return AppConfirmDialog.show(
      context,
      title: 'Delete Topic?',
      message: message,
      confirmLabel: 'Delete',
      icon: CupertinoIcons.trash_fill,
      isDestructive: true,
    );
  }
}
