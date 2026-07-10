import 'raby_enums.dart';

class Tag {
  const Tag({
    required this.id,
    required this.name,
    required this.tagKind,
    required this.isSystem,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.rabbitId,
    this.colorToken,
    this.iconName,
    this.deletedAt,
  });

  final String id;
  final String? rabbitId;
  final String name;
  final TagKind tagKind;
  final bool isSystem;
  final String? colorToken;
  final String? iconName;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
