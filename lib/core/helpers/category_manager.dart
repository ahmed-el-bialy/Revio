import 'package:hive_ce/hive_ce.dart';

class CategoryManager {
  static const String _boxName = 'custom_categories_box';
  static const List<String> coreCategories = [
    'General',
    'Science',
    'Math',
    'Language',
  ];

  static Box<String>? get _box {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<String>(_boxName);
    }
    return null;
  }

  /// Get all custom user-added categories saved in Hive
  static List<String> getCustomCategories() {
    final b = _box;
    if (b == null) return [];
    return b.values.toList();
  }

  /// Save a new custom category if not already existing
  static Future<bool> addCustomCategory(String categoryName) async {
    final trimmed = categoryName.trim();
    if (trimmed.isEmpty) return false;

    final existing = getCustomCategories();
    final isDuplicate = existing.any((c) => c.toLowerCase() == trimmed.toLowerCase()) ||
        coreCategories.any((c) => c.toLowerCase() == trimmed.toLowerCase());

    if (isDuplicate) return false;

    final b = _box ?? await Hive.openBox<String>(_boxName);
    await b.add(trimmed);
    return true;
  }

  /// Check if a category already exists (case-insensitive)
  static bool categoryExists(String categoryName, List<String> currentList) {
    final target = categoryName.trim().toLowerCase();
    return currentList.any((c) => c.trim().toLowerCase() == target);
  }
}
