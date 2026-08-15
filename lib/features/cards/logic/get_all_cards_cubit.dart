import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/cards_repo.dart';
import 'get_all_cards_state.dart';

class GetAllCardsCubit extends Cubit<GetAllCardsState> {
  final CardsRepo _cardsRepo;
  StreamSubscription? _subscription;

  GetAllCardsCubit(this._cardsRepo) : super(CardsInitial()) {
    _subscribeToCards();
  }

  void _subscribeToCards() {
    emit(CardsLoading());
    _subscription?.cancel();
    _subscription = _cardsRepo.watchCards().listen(
      (cards) {
        emit(CardsLoadedSuccess(cards));
      },
      onError: (e) {
        emit(CardsError('there was an Error: ${e.toString()}'));
      },
    );
  }

  // fetchAllCards is now handled by the stream subscription.
  // We keep the method signature but it's redundant.
  Future<void> fetchAllCards() async {
    _subscribeToCards();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
