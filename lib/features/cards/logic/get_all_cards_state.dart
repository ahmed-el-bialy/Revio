import '../data/models/card_model.dart';

abstract class GetAllCardsState {}

class CardsInitial extends GetAllCardsState {}

class CardsLoading extends GetAllCardsState {}

class CardsLoadedSuccess extends GetAllCardsState {
  final List<CardModel> cards;

  CardsLoadedSuccess(this.cards);
}

class CardsError extends GetAllCardsState {
  final String errorMessage;

  CardsError(this.errorMessage);
}
