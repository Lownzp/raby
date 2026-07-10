import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../domain/models/weight_record.dart';

final weightRecordsProvider = StreamProvider.family<List<WeightRecord>, String>(
  (ref, rabbitId) {
    return ref.watch(weightRepositoryProvider).watchRecords(rabbitId);
  },
);

final weightChartRecordsProvider =
    StreamProvider.family<List<WeightRecord>, String>((ref, rabbitId) {
      return ref.watch(weightRepositoryProvider).watchRecordsForChart(rabbitId);
    });

final weightRecordProvider =
    FutureProvider.family<WeightRecord?, ({String rabbitId, String recordId})>((
      ref,
      args,
    ) async {
      final records = await ref.watch(
        weightRecordsProvider(args.rabbitId).future,
      );
      for (final record in records) {
        if (record.id == args.recordId) {
          return record;
        }
      }
      return null;
    });
