import 'package:code_alpha_flash_card_app/core/data/repo/cards_repo.dart';
import 'package:code_alpha_flash_card_app/features/add_new_card/logic/add_card_cubit.dart';
import 'package:code_alpha_flash_card_app/features/add_new_card/ui/add_new_card_screen.dart';
import 'package:code_alpha_flash_card_app/features/home/ui/home_screen.dart';
import 'package:code_alpha_flash_card_app/features/quiz/ui/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/review/logic/delete_card/delete_card_cubit.dart';
import '../../features/review/logic/edit_card/edit_card_cubit.dart';
import '../../features/review/ui/review_cards_screen.dart';
import '../constants/app_constants.dart';
import '../logic/get_all_cards_cubit.dart';

class AppRouter {
  Route generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppConstants.homeScreen:
        return _fadeRoute(
          BlocProvider(
            create: (context) => GetAllCardsCubit(CardsRepo())..fetchAllCards(),
            child: const HomeScreen(),
          ),
        );
      case AppConstants.newCardScreen:
        return _fadeRoute(
          BlocProvider(
            create: (context) => AddCardCubit(CardsRepo()),
            child: const AddCardScreen(),
          ),
        );

      case AppConstants.reviewCardsScreen:
        return _fadeRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    GetAllCardsCubit(CardsRepo())..fetchAllCards(),
              ),
              BlocProvider(create: (context) => DeleteCardCubit(CardsRepo())),
              BlocProvider(create: (context) => EditCardCubit(CardsRepo())),
            ],
            child: const ReviewCardsScreen(),
          ),
        );

      case AppConstants.quizScreen:
        return _fadeRoute(
          BlocProvider(
            create: (context) => GetAllCardsCubit(CardsRepo())..fetchAllCards(),
            child: const QuizScreen(),
          ),
        );

      default:
        return _fadeRoute(const HomeScreen());
    }
  }

  PageRouteBuilder _fadeRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
