import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../review/logic/delete_card/delete_card_cubit.dart';
import '../../data/models/card_model.dart';

class ConfirmMessage {
  static Future<bool> show(
    BuildContext context, {
    required DeleteCardCubit deleteCubit,
    required CardModel cardModel,
  }) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Delete Flashcard',
      message:
          'Are you sure you want to delete this card? This action cannot be undone.',
      confirmLabel: 'Delete',
      icon: CupertinoIcons.trash_fill,
      isDestructive: true,
    );
    if (confirmed) {
      deleteCubit.emitDeleteCard(cardModel.id);
    }
    return confirmed;
  }
}
