import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../domain/domain_validation_exception.dart';
import '../../../domain/models/weight_record.dart';

class WeightEditorInput {
  const WeightEditorInput({
    required this.rabbitId,
    required this.recordedAt,
    required this.weightGrams,
    this.note,
  });

  final String rabbitId;
  final DateTime recordedAt;
  final int weightGrams;
  final String? note;
}

final weightEditorControllerProvider = Provider<WeightEditorController>((ref) {
  return WeightEditorController(ref);
});

class WeightEditorController {
  const WeightEditorController(this._ref);

  final Ref _ref;

  Future<void> create(WeightEditorInput input) {
    _validateInput(input);
    final now = _ref.read(clockProvider)();
    final record = WeightRecord(
      id: _ref.read(uuidProvider).v4(),
      rabbitId: input.rabbitId,
      recordedAt: _recordedAt(input.recordedAt),
      weightGrams: input.weightGrams,
      note: _trimToNull(input.note),
      createdAt: now,
      updatedAt: now,
    );
    return _ref.read(weightRepositoryProvider).createRecord(record);
  }

  Future<void> update({
    required WeightRecord existing,
    required WeightEditorInput input,
  }) {
    _validateInput(input);
    final record = WeightRecord(
      id: existing.id,
      rabbitId: input.rabbitId,
      recordedAt: _recordedAt(input.recordedAt),
      weightGrams: input.weightGrams,
      note: _trimToNull(input.note),
      photoPath: existing.photoPath,
      bcsScore: existing.bcsScore,
      createdAt: existing.createdAt,
      updatedAt: _ref.read(clockProvider)(),
      deletedAt: existing.deletedAt,
    );
    return _ref.read(weightRepositoryProvider).updateRecord(record);
  }

  Future<void> delete(String recordId) {
    return _ref.read(weightRepositoryProvider).softDeleteRecord(recordId);
  }

  void _validateInput(WeightEditorInput input) {
    if (input.weightGrams <= 0 || input.weightGrams > 20000) {
      throw const DomainValidationException('体重需要在 1-20000g 之间');
    }
    final recordedDay = _dateOnly(input.recordedAt.toLocal());
    final today = _dateOnly(_ref.read(clockProvider)().toLocal());
    if (recordedDay.isAfter(today)) {
      throw const DomainValidationException('记录日期不能晚于今天');
    }
  }
}

DateTime _recordedAt(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day, 12).toUtc();
}

DateTime _dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String? _trimToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
