import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/database/app_database.dart';
import '../../data/media/media_storage_service.dart';
import '../../data/repositories/drift_diary_repository.dart';
import '../../data/repositories/drift_rabbit_repository.dart';
import '../../data/repositories/drift_tag_repository.dart';
import '../../data/repositories/drift_weight_repository.dart';
import '../../domain/repositories/diary_repository.dart';
import '../../domain/repositories/rabbit_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/repositories/weight_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

final clockProvider = Provider<DateTime Function()>((ref) {
  return () => DateTime.now().toUtc();
});

final mediaStorageServiceProvider = Provider<MediaStorageService>((ref) {
  return const MediaStorageService();
});

final rabbitRepositoryProvider = Provider<RabbitRepository>((ref) {
  return DriftRabbitRepository(
    ref.watch(appDatabaseProvider),
    now: ref.watch(clockProvider),
  );
});

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DriftDiaryRepository(
    ref.watch(appDatabaseProvider),
    uuid: ref.watch(uuidProvider),
    now: ref.watch(clockProvider),
  );
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return DriftTagRepository(
    ref.watch(appDatabaseProvider),
    uuid: ref.watch(uuidProvider),
    now: ref.watch(clockProvider),
  );
});

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return DriftWeightRepository(
    ref.watch(appDatabaseProvider),
    now: ref.watch(clockProvider),
  );
});
