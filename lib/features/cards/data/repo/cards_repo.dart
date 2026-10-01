import 'package:hive_ce/hive_ce.dart';

import '../models/card_model.dart';

class CardsRepo {
  static const String _boxName = 'flash_cards_box';

  static final CardsRepo _instance = CardsRepo._internal();
  factory CardsRepo() => _instance;
  CardsRepo._internal();

  Box<CardModel> get _box => Hive.box<CardModel>(_boxName);

  Future<void> saveCard(CardModel card) async {
    await _box.put(card.id, card);
  }

  Future<List<CardModel>> getAllCards() async {
    return _box.values.toList();
  }

  Future<void> updateCard(CardModel card) async {
    await _box.put(card.id, card);
  }

  Future<void> deleteCard(String cardId) async {
    await _box.delete(cardId);
  }

  Future<void> toggleFavorite(String cardId) async {
    final card = _box.get(cardId);
    if (card != null) {
      final updatedCard = CardModel(
        id: card.id,
        category: card.category,
        front: card.front,
        hint: card.hint,
        back: card.back,
        isFavorite: !(card.isFavorite ?? false),
        difficulty: card.difficulty,
        createdAt: card.createdAt,
      );
      await _box.put(cardId, updatedCard);
    }
  }

  List<CardModel> searchCards(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _box.values.toList();

    return _box.values.where((card) {
      return card.front.toLowerCase().contains(normalizedQuery) ||
          card.back.toLowerCase().contains(normalizedQuery) ||
          (card.hint?.toLowerCase().contains(normalizedQuery) ?? false) ||
          (card.category?.toLowerCase().contains(normalizedQuery) ?? false);
    }).toList();
  }

  List<CardModel> getCardsByCategory(String category) {
    return _box.values
        .where((card) => card.category == category)
        .toList();
  }

  List<CardModel> getFavoriteCards() {
    return _box.values
        .where((card) => card.isFavorite == true)
        .toList();
  }

  Stream<List<CardModel>> watchCards() async* {
    yield _box.values.toList();
    await for (final _ in _box.watch()) {
      yield _box.values.toList();
    }
  }
}