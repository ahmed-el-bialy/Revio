import 'package:code_alpha_flash_card_app/core/constants/app_constants.dart';
import 'package:code_alpha_flash_card_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'core/data/models/card_model.dart';
import 'core/routing/app_router.dart';
import 'hive_registrar.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapters();

  await Hive.openBox<CardModel>('flash_cards_box');

  runApp(Revio(appRouter: AppRouter()));
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
      ensureScreenSize: true,
      builder: (_, child) {
        return MaterialApp(
          initialRoute: AppConstants.homeScreen,
          onGenerateRoute: appRouter.generateRoute,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.darkBackground,
          ),
        );
      },
    );
  }
}
