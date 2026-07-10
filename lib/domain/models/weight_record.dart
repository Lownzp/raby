class WeightRecord {
  const WeightRecord({
    required this.id,
    required this.rabbitId,
    required this.recordedAt,
    required this.weightGrams,
    required this.createdAt,
    required this.updatedAt,
    this.note,
    this.photoPath,
    this.bcsScore,
    this.deletedAt,
  });

  final String id;
  final String rabbitId;
  final DateTime recordedAt;
  final int weightGrams;
  final String? note;
  final String? photoPath;
  final int? bcsScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
