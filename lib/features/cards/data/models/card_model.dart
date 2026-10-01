import 'package:hive_ce/hive_ce.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? category;

  @HiveField(2)
  final String front;

  @HiveField(3)
  final String? hint;

  @HiveField(4)
  final String back;

  @HiveField(5)
  final bool? isFavorite;

  @HiveField(6)
  final int? difficulty;

  @HiveField(7)
  final DateTime? createdAt;

  CardModel({
    required this.id,
    this.category,
    required this.front,
    this.hint,
    required this.back,
    this.isFavorite,
    this.difficulty,
    this.createdAt,
  });
}