class Diary {
  const Diary({
    required this.id,
    required this.rabbitId,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
    this.content,
    this.deletedAt,
  });

  final String id;
  final String rabbitId;
  final DateTime recordedAt;
  final String? content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
