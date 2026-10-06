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
    final list = _box.values.toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(2020))
        .compareTo(a.createdAt ?? DateTime(2020)));
    return list;
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
    final list = _box.values.toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(2020))
        .compareTo(a.createdAt ?? DateTime(2020)));

    if (normalizedQuery.isEmpty) return list;

    return list.where((card) {
      return card.front.toLowerCase().contains(normalizedQuery) ||
          card.back.toLowerCase().contains(normalizedQuery) ||
          (card.hint?.toLowerCase().contains(normalizedQuery) ?? false) ||
          (card.category?.toLowerCase().contains(normalizedQuery) ?? false);
    }).toList();
  }

  List<CardModel> getCardsByCategory(String category) {
    final list = _box.values
        .where((card) => card.category == category)
        .toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(2020))
        .compareTo(a.createdAt ?? DateTime(2020)));
    return list;
  }

  List<CardModel> getFavoriteCards() {
    final list = _box.values
        .where((card) => card.isFavorite == true)
        .toList();
    list.sort((a, b) => (b.createdAt ?? DateTime(2020))
        .compareTo(a.createdAt ?? DateTime(2020)));
    return list;
  }

  Stream<List<CardModel>> watchCards() async* {
    List<CardModel> getSorted() {
      final list = _box.values.toList();
      list.sort((a, b) => (b.createdAt ?? DateTime(2020))
          .compareTo(a.createdAt ?? DateTime(2020)));
      return list;
    }

    yield getSorted();
    await for (final _ in _box.watch()) {
      yield getSorted();
    }
  }
}
