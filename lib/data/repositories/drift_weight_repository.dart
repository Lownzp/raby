import '../../domain/domain_validation_exception.dart';
import '../../domain/models/weight_record.dart';
import '../../domain/repositories/weight_repository.dart';
import '../database/app_database.dart';
import 'drift_mappers.dart';

class DriftWeightRepository implements WeightRepository {
  DriftWeightRepository(this._database, {DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc());

  final AppDatabase _database;
  final DateTime Function() _now;

  WeightDao get _dao => _database.weightDao;

  @override
  Stream<List<WeightRecord>> watchRecords(String rabbitId) {
    return _dao
        .watchRecords(rabbitId)
        .map((rows) => rows.map(weightRecordFromRow).toList(growable: false));
  }

  @override
  Stream<List<WeightRecord>> watchRecordsForChart(String rabbitId) {
    return _dao
        .watchRecordsForChart(rabbitId)
        .map((rows) => rows.map(weightRecordFromRow).toList(growable: false));
  }

  @override
  Future<void> createRecord(WeightRecord record) {
    _validateRecord(record);
    return _dao.insertRecord(weightRecordToCompanion(record));
  }

  @override
  Future<void> updateRecord(WeightRecord record) {
    _validateRecord(record);
    return _dao.updateRecord(weightRecordToCompanion(record));
  }

  @override
  Future<void> softDeleteRecord(String id) {
    return _dao.softDeleteRecord(id, dateTimeToMillis(_now()));
  }

  void _validateRecord(WeightRecord record) {
    if (record.weightGrams <= 0 || record.weightGrams > 20000) {
      throw const DomainValidationException('体重需要在 1-20000g 之间');
    }
    final bcsScore = record.bcsScore;
    if (bcsScore != null && (bcsScore < 1 || bcsScore > 5)) {
      throw const DomainValidationException('BCS 评分需要在 1-5 之间');
    }
  }
}
