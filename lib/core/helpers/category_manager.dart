import 'package:hive_ce/hive_ce.dart';
import '../../features/cards/data/models/card_model.dart';

class CategoryManager {
  static const String _boxName = 'custom_categories_box';
  static const String _deletedCoreBoxName = 'deleted_core_categories_box';
  static const String _cardsBoxName = 'flash_cards_box';

  static const List<String> coreCategories = [
    'No Topic',
    'General',
    'Science',
    'Math',
    'Language',
  ];

  static Box<String>? get _customBox {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<String>(_boxName);
    }
    return null;
  }

  static Box<String>? get _deletedCoreBox {
    if (Hive.isBoxOpen(_deletedCoreBoxName)) {
      return Hive.box<String>(_deletedCoreBoxName);
    }
    return null;
  }

  static Box<CardModel>? get _cardsBox {
    if (Hive.isBoxOpen(_cardsBoxName)) {
      return Hive.box<CardModel>(_cardsBoxName);
    }
    return null;
  }

  /// Get all custom user-added categories saved in Hive
  static List<String> getCustomCategories() {
    final b = _customBox;
    if (b == null) return [];
    return b.values.toList();
  }

  /// Get deleted core categories
  static List<String> getDeletedCoreCategories() {
    final b = _deletedCoreBox;
    if (b == null) return [];
    final deleted = b.values.toList();
    deleted.removeWhere((c) => c.toLowerCase() == 'no topic');
    return deleted;
  }

  /// Get active core categories (excluding deleted ones, but 'No Topic' is never deleted)
  static List<String> getActiveCoreCategories() {
    final deleted = getDeletedCoreCategories();
    final active = coreCategories.where((c) => !deleted.contains(c)).toList();
    if (!active.any((c) => c.toLowerCase() == 'no topic')) {
      active.insert(0, 'No Topic');
    }
    return active;
  }

  /// Save a new custom category if not already existing
  static Future<bool> addCustomCategory(String categoryName) async {
    final trimmed = categoryName.trim();
    if (trimmed.isEmpty) return false;

    // If it was a deleted core category, un-delete it!
    final deletedBox = _deletedCoreBox ?? await Hive.openBox<String>(_deletedCoreBoxName);
    final deletedKeys = deletedBox.keys.toList();
    for (var key in deletedKeys) {
      final val = deletedBox.get(key);
      if (val != null && val.toLowerCase() == trimmed.toLowerCase() && val.toLowerCase() != 'no topic') {
        await deletedBox.delete(key);
        return true;
      }
    }

    final existingCustom = getCustomCategories();
    final isDuplicate = existingCustom.any((c) => c.toLowerCase() == trimmed.toLowerCase()) ||
        coreCategories.any((c) => c.toLowerCase() == trimmed.toLowerCase());

    if (isDuplicate) return false;

    final b = _customBox ?? await Hive.openBox<String>(_boxName);
    await b.add(trimmed);
    return true;
  }

  /// Rename a category (whether core or custom) and update all associated cards
  static Future<bool> renameCategory(String oldName, String newName) async {
    final trimmedOld = oldName.trim();
    if (trimmedOld.toLowerCase() == 'no topic') return false;

    final trimmedNew = newName.trim();
    if (trimmedNew.isEmpty || trimmedOld.toLowerCase() == trimmedNew.toLowerCase()) {
      return false;
    }

    // Check duplicate
    final allCurrent = [...getActiveCoreCategories(), ...getCustomCategories()];
    if (allCurrent.any((c) => c.toLowerCase() == trimmedNew.toLowerCase())) {
      return false;
    }

    // Check if oldName is a core category
    final isCore = coreCategories.any((c) => c.toLowerCase() == trimmedOld.toLowerCase());

    if (isCore) {
      // Hide old core category and add newName as custom category
      final matchingCore = coreCategories.firstWhere((c) => c.toLowerCase() == trimmedOld.toLowerCase());
      final deletedBox = _deletedCoreBox ?? await Hive.openBox<String>(_deletedCoreBoxName);
      if (!getDeletedCoreCategories().contains(matchingCore)) {
        await deletedBox.add(matchingCore);
      }
      final customBox = _customBox ?? await Hive.openBox<String>(_boxName);
      await customBox.add(trimmedNew);
    } else {
      // Update in custom categories box if it's custom
      final b = _customBox;
      if (b != null) {
        final keys = b.keys.toList();
        for (var key in keys) {
          final val = b.get(key);
          if (val != null && val.trim().toLowerCase() == trimmedOld.toLowerCase()) {
            await b.put(key, trimmedNew);
          }
        }
      }
    }

    // Update cards in cards box
    final cardsBox = _cardsBox ?? await Hive.openBox<CardModel>(_cardsBoxName);
    for (var card in cardsBox.values) {
      if (card.category == trimmedOld) {
        final updated = CardModel(
          id: card.id,
          category: trimmedNew,
          front: card.front,
          hint: card.hint,
          back: card.back,
          isFavorite: card.isFavorite,
          difficulty: card.difficulty,
          createdAt: card.createdAt,
        );
        await cardsBox.put(card.id, updated);
      }
    }

    return true;
  }

  /// Delete any category and reassign its cards to 'No Topic' ('No Topic' cannot be deleted)
  static Future<void> deleteCategoryAndReassignCards(String categoryName) async {
    final trimmed = categoryName.trim();
    if (trimmed.toLowerCase() == 'no topic') return; // Immutable system default
    
    // Check if core category
    if (coreCategories.any((c) => c.toLowerCase() == trimmed.toLowerCase())) {
      final matchingCore = coreCategories.firstWhere((c) => c.toLowerCase() == trimmed.toLowerCase());
      if (matchingCore.toLowerCase() == 'no topic') return;
      
      final deletedBox = _deletedCoreBox ?? await Hive.openBox<String>(_deletedCoreBoxName);
      if (!getDeletedCoreCategories().contains(matchingCore)) {
        await deletedBox.add(matchingCore);
      }
    } else {
      // Delete from custom categories box
      final b = _customBox;
      if (b != null) {
        final keys = b.keys.toList();
        for (var key in keys) {
          final val = b.get(key);
          if (val != null && val.trim().toLowerCase() == trimmed.toLowerCase()) {
            await b.delete(key);
          }
        }
      }
    }

    // Reassign cards to 'No Topic'
    final cardsBox = _cardsBox ?? await Hive.openBox<CardModel>(_cardsBoxName);
    for (var card in cardsBox.values) {
      if (card.category == trimmed) {
        final updated = CardModel(
          id: card.id,
          category: 'No Topic',
          front: card.front,
          hint: card.hint,
          back: card.back,
          isFavorite: card.isFavorite,
          difficulty: card.difficulty,
          createdAt: card.createdAt,
        );
        await cardsBox.put(card.id, updated);
      }
    }
  }

  /// Check if a category already exists (case-insensitive)
  static bool categoryExists(String categoryName, List<String> currentList) {
    final target = categoryName.trim().toLowerCase();
    return currentList.any((c) => c.trim().toLowerCase() == target);
  }
}
