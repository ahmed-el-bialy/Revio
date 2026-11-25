
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:material_ui/material_ui.dart';

import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theming/app_themes.dart';
import 'features/cards/data/models/card_model.dart';
import 'features/cards/data/repo/cards_repo.dart';
import 'features/cards/logic/get_all_cards_cubit.dart';
import 'hive_registrar.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch framework errors for debugging
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  await Hive.initFlutter();
  Hive.registerAdapters();

  await _openHiveBoxes();

  runApp(Revio(appRouter: AppRouter()));
}

/// Opens all Hive boxes with per-box error recovery.
/// If a box is corrupted, it is deleted and re-opened cleanly.
Future<void> _openHiveBoxes() async {
  await _safeOpenBox<CardModel>('flash_cards_box');
  await _safeOpenBox<String>('custom_categories_box');
  await _safeOpenBox<String>('deleted_core_categories_box');
  await _safeOpenBox<dynamic>('quiz_history_box');
}

Future<void> _safeOpenBox<T>(String boxName) async {
  try {
    await Hive.openBox<T>(boxName);
  } catch (_) {
    try {
      await Hive.deleteBoxFromDisk(boxName);
    } catch (_) {}
    await Hive.openBox<T>(boxName);
  }
}

class Revio extends StatelessWidget {
  const Revio({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => GetAllCardsCubit(CardsRepo())..fetchAllCards(),
          child: MaterialApp(
            initialRoute: AppConstants.homeScreen,
            onGenerateRoute: appRouter.generateRoute,
            debugShowCheckedModeBanner: false,
            theme: AppThemes.darkTheme,
          ),
        );
      },
    );
  }
}

