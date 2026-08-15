import 'package:hive_ce/hive_ce.dart';

import '../models/card_model.dart';

class CardsRepo {
  static const String _boxName = 'flash_cards_box';

  Future<void> saveCard(CardModel card) async {
    final box = await Hive.openBox<CardModel>(_boxName);
    await box.put(card.id, card);
  }

  Future<List<CardModel>> getAllCards() async {
    final box = await Hive.openBox<CardModel>(_boxName);
    return box.values.toList();
  }

  Future<void> updateCard(CardModel card) async {
    final box = await Hive.openBox<CardModel>(_boxName);
    await box.put(card.id, card);
  }

  Future<void> deleteCard(String cardId) async {
    final box = await Hive.openBox<CardModel>(_boxName);
    await box.delete(cardId);
  }

  Stream<List<CardModel>> watchCards() async* {
    final box = await Hive.openBox<CardModel>(_boxName);
    yield box.values.toList();
    await for (final _ in box.watch()) {
      yield box.values.toList();
    }
  }
}