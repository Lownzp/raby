import 'raby_enums.dart';

class Rabbit {
  const Rabbit({
    required this.id,
    required this.name,
    required this.sex,
    required this.breed,
    required this.furColor,
    required this.createdAt,
    required this.updatedAt,
    this.birthDate,
    this.adoptedDate,
    this.avatarPath,
    this.source,
    this.neuteredStatus,
    this.neuteredDate,
    this.chipNumber,
    this.initialWeightGrams,
    this.personalityTags = const [],
    this.favoriteFoods,
    this.favoriteToys,
    this.passedAwayDate,
    this.deletedAt,
  });

  final String id;
  final String name;
  final RabbitSex sex;
  final String? birthDate;
  final String? adoptedDate;
  final String breed;
  final String furColor;
  final String? avatarPath;
  final String? source;
  final NeuteredStatus? neuteredStatus;
  final String? neuteredDate;
  final String? chipNumber;
  final int? initialWeightGrams;
  final List<String> personalityTags;
  final String? favoriteFoods;
  final String? favoriteToys;
  final String? passedAwayDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
