import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/data/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creates v0.1 indexes', () async {
    final rows = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' AND name NOT LIKE 'sqlite_%';",
        )
        .get();

    final names = rows.map((row) => row.data['name'] as String).toSet();

    expect(
      names,
      containsAll({
        'idx_rabbits_deleted_at',
        'idx_rabbits_updated_at',
        'idx_diaries_rabbit_recorded_at',
        'idx_diaries_deleted_at',
        'idx_diaries_updated_at',
        'idx_diary_media_diary_order',
        'idx_diary_media_deleted_at',
        'idx_diary_media_updated_at',
        'idx_tags_rabbit_id',
        'idx_tags_kind',
        'idx_tags_deleted_at',
        'idx_tags_updated_at',
        'idx_diary_tags_diary_id',
        'idx_diary_tags_tag_id',
        'idx_diary_tags_deleted_at',
        'idx_diary_tags_updated_at',
        'idx_weight_records_rabbit_recorded_at',
        'idx_weight_records_deleted_at',
        'idx_weight_records_updated_at',
      }),
    );
  });
}
