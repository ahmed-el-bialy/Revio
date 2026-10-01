import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/card_model.dart';
import '../data/repo/cards_repo.dart';
import 'get_all_cards_state.dart';

class GetAllCardsCubit extends Cubit<GetAllCardsState> {
  final CardsRepo _cardsRepo;
  StreamSubscription? _subscription;

  GetAllCardsCubit(this._cardsRepo) : super(CardsInitial());

  void fetchAllCards() {
    if (_subscription != null) return;
    emit(CardsLoading());
    _subscription = _cardsRepo.watchCards().listen(
      (cards) {
        emit(CardsLoadedSuccess(cards));
      },
      onError: (e) {
        emit(CardsError('there was an Error: ${e.toString()}'));
      },
    );
  }

  List<CardModel> searchCards(String query) {
    return _cardsRepo.searchCards(query);
  }

  List<CardModel> getCardsByCategory(String category) {
    return _cardsRepo.getCardsByCategory(category);
  }

  List<CardModel> getFavoriteCards() {
    return _cardsRepo.getFavoriteCards();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
