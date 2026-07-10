import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/app/providers/repository_providers.dart';
import 'package:raby/domain/domain_validation_exception.dart';
import 'package:raby/domain/models/weight_record.dart';
import 'package:raby/domain/repositories/weight_repository.dart';
import 'package:raby/features/weight/application/weight_editor_controller.dart';

void main() {
  test(
    'creates a weight record with trimmed note and current timestamps',
    () async {
      final repository = _FakeWeightRepository();
      final container = _container(repository);
      addTearDown(container.dispose);

      await container
          .read(weightEditorControllerProvider)
          .create(
            WeightEditorInput(
              rabbitId: 'rabbit-1',
              recordedAt: DateTime(2026, 6, 9, 9),
              weightGrams: 1280,
              note: '  饭前称重  ',
            ),
          );

      final record = repository.records.single;
      expect(record.rabbitId, 'rabbit-1');
      expect(record.weightGrams, 1280);
      expect(record.note, '饭前称重');
      expect(record.recordedAt, DateTime(2026, 6, 9, 12).toUtc());
      expect(record.createdAt, _now);
      expect(record.updatedAt, _now);
    },
  );

  test(
    'updates a weight record while preserving identity and createdAt',
    () async {
      final repository = _FakeWeightRepository();
      final container = _container(repository);
      addTearDown(container.dispose);
      final existing = WeightRecord(
        id: 'weight-1',
        rabbitId: 'rabbit-1',
        recordedAt: DateTime.utc(2026, 6, 8, 12),
        weightGrams: 1200,
        note: '旧备注',
        createdAt: DateTime.utc(2026, 6, 8, 1),
        updatedAt: DateTime.utc(2026, 6, 8, 2),
      );
      repository.records.add(existing);

      await container
          .read(weightEditorControllerProvider)
          .update(
            existing: existing,
            input: WeightEditorInput(
              rabbitId: 'rabbit-1',
              recordedAt: DateTime.utc(2026, 6, 9),
              weightGrams: 1290,
              note: '',
            ),
          );

      final record = repository.records.single;
      expect(record.id, 'weight-1');
      expect(record.createdAt, existing.createdAt);
      expect(record.updatedAt, _now);
      expect(record.weightGrams, 1290);
      expect(record.note, isNull);
    },
  );

  test('rejects invalid and future weight inputs', () async {
    final repository = _FakeWeightRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    final controller = container.read(weightEditorControllerProvider);

    expect(
      () => controller.create(
        WeightEditorInput(
          rabbitId: 'rabbit-1',
          recordedAt: DateTime.utc(2026, 6, 9),
          weightGrams: 0,
        ),
      ),
      throwsA(isA<DomainValidationException>()),
    );
    expect(
      () => controller.create(
        WeightEditorInput(
          rabbitId: 'rabbit-1',
          recordedAt: DateTime.utc(2026, 6, 10),
          weightGrams: 1280,
        ),
      ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('deletes a weight record through repository', () async {
    final repository = _FakeWeightRepository();
    final container = _container(repository);
    addTearDown(container.dispose);
    repository.records.add(
      WeightRecord(
        id: 'weight-1',
        rabbitId: 'rabbit-1',
        recordedAt: DateTime.utc(2026, 6, 9, 12),
        weightGrams: 1280,
        createdAt: _now,
        updatedAt: _now,
      ),
    );

    await container.read(weightEditorControllerProvider).delete('weight-1');

    expect(repository.records, isEmpty);
  });
}

ProviderContainer _container(_FakeWeightRepository repository) {
  return ProviderContainer(
    overrides: [
      weightRepositoryProvider.overrideWithValue(repository),
      clockProvider.overrideWithValue(() => _now),
    ],
  );
}

final _now = DateTime.utc(2026, 6, 9, 8);

class _FakeWeightRepository implements WeightRepository {
  final List<WeightRecord> records = [];
  final List<void Function()> _listeners = [];

  @override
  Stream<List<WeightRecord>> watchRecords(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_records(rabbitId, ascending: false));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
  }

  @override
  Stream<List<WeightRecord>> watchRecordsForChart(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_records(rabbitId, ascending: true));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
  }

  @override
  Future<void> createRecord(WeightRecord record) async {
    records.add(record);
    _emit();
  }

  @override
  Future<void> updateRecord(WeightRecord record) async {
    final index = records.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      records.add(record);
    } else {
      records[index] = record;
    }
    _emit();
  }

  @override
  Future<void> softDeleteRecord(String id) async {
    records.removeWhere((record) => record.id == id);
    _emit();
  }

  List<WeightRecord> _records(String rabbitId, {required bool ascending}) {
    final visible = records
        .where((record) => record.rabbitId == rabbitId)
        .toList();
    visible.sort((a, b) {
      final compare = a.recordedAt.compareTo(b.recordedAt);
      return ascending ? compare : -compare;
    });
    return List.unmodifiable(visible);
  }

  void _emit() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
