import 'package:cupertino_ui/cupertino_ui.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';

class QuizExitDialog {
  static Future<bool> show(BuildContext context) {
    return AppConfirmDialog.show(
      context,
      title: 'Exit Quiz?',
      message: 'Your current quiz progress will be lost if you leave now.',
      confirmLabel: 'Exit',
      icon: CupertinoIcons.exclamationmark_triangle_fill,
      isDestructive: true,
    );
  }
}
