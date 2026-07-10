import '../models/weight_record.dart';

abstract interface class WeightRepository {
  Stream<List<WeightRecord>> watchRecords(String rabbitId);
  Stream<List<WeightRecord>> watchRecordsForChart(String rabbitId);
  Future<void> createRecord(WeightRecord record);
  Future<void> updateRecord(WeightRecord record);
  Future<void> softDeleteRecord(String id);
}
