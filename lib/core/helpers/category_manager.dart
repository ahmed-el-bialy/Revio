import 'package:hive_ce/hive_ce.dart';

class CategoryManager {
  static const String _boxName = 'custom_categories_box';
  static const String _deletedCoreBoxName = 'deleted_core_categories_box';
  
  static const List<String> coreCategories = [
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
    return b.values.toList();
  }

  /// Get active core categories (excluding deleted ones)
  static List<String> getActiveCoreCategories() {
    final deleted = getDeletedCoreCategories();
    return coreCategories.where((c) => !deleted.contains(c)).toList();
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
      if (val != null && val.toLowerCase() == trimmed.toLowerCase()) {
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

  /// Delete any category (whether core or custom)
  static Future<void> deleteCategory(String categoryName) async {
    final trimmed = categoryName.trim();
    
    // Check if core category
    if (coreCategories.any((c) => c.toLowerCase() == trimmed.toLowerCase())) {
      final matchingCore = coreCategories.firstWhere((c) => c.toLowerCase() == trimmed.toLowerCase());
      final deletedBox = _deletedCoreBox ?? await Hive.openBox<String>(_deletedCoreBoxName);
      if (!getDeletedCoreCategories().contains(matchingCore)) {
        await deletedBox.add(matchingCore);
      }
      return;
    }

    // Otherwise delete from custom categories
    final b = _customBox;
    if (b == null) return;
    
    final keys = b.keys.toList();
    for (var key in keys) {
      final val = b.get(key);
      if (val != null && val.trim().toLowerCase() == trimmed.toLowerCase()) {
        await b.delete(key);
      }
    }
  }

  /// Check if a category already exists (case-insensitive)
  static bool categoryExists(String categoryName, List<String> currentList) {
    final target = categoryName.trim().toLowerCase();
    return currentList.any((c) => c.trim().toLowerCase() == target);
  }
}
