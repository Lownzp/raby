import 'package:uuid/uuid.dart';

import '../../domain/domain_validation_exception.dart';
import '../../domain/models/raby_enums.dart';
import '../../domain/models/tag.dart';
import '../../domain/repositories/tag_repository.dart';
import '../database/app_database.dart';
import 'drift_mappers.dart';

class DriftTagRepository implements TagRepository {
  DriftTagRepository(this._database, {Uuid? uuid, DateTime Function()? now})
    : _uuid = uuid ?? const Uuid(),
      _now = now ?? (() => DateTime.now().toUtc());

  final AppDatabase _database;
  final Uuid _uuid;
  final DateTime Function() _now;

  TagDao get _dao => _database.tagDao;

  @override
  Stream<List<Tag>> watchAvailableTags(String rabbitId) {
    return _dao
        .watchAvailableTags(rabbitId)
        .map((rows) => rows.map(tagFromRow).toList(growable: false));
  }

  @override
  Future<List<Tag>> getAvailableTags(String rabbitId) async {
    final rows = await _dao.getAvailableTags(rabbitId);
    return rows.map(tagFromRow).toList(growable: false);
  }

  @override
  Future<void> ensureSystemTagsSeeded() async {
    final now = _now();
    for (var i = 0; i < _systemTagSeeds.length; i++) {
      final seed = _systemTagSeeds[i];
      final existing = await _dao.getSystemTagByName(seed.name);
      if (existing != null) {
        continue;
      }
      await _dao.insertTag(
        tagToCompanion(
          Tag(
            id: _uuid.v4(),
            name: seed.name,
            tagKind: seed.tagKind,
            isSystem: true,
            colorToken: seed.colorToken,
            iconName: seed.iconName,
            sortOrder: i,
            createdAt: now,
            updatedAt: now,
          ),
        ),
      );
    }
  }

  @override
  Future<Tag> createCustomTag({
    required String rabbitId,
    required String name,
    TagKind tagKind = TagKind.normal,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || trimmedName.length > 12) {
      throw const DomainValidationException('标签名需要是 1-12 个字符');
    }
    final availableTags = await getAvailableTags(rabbitId);
    final duplicated = availableTags.any(
      (tag) =>
          !tag.isSystem &&
          tag.rabbitId == rabbitId &&
          tag.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicated) {
      throw const DomainValidationException('同一只兔子的标签名不能重复');
    }

    final now = _now();
    final tag = Tag(
      id: _uuid.v4(),
      rabbitId: rabbitId,
      name: trimmedName,
      tagKind: tagKind,
      isSystem: false,
      colorToken: tagKind == TagKind.milestone ? 'secondary' : 'primary',
      sortOrder: availableTags.length,
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insertTag(tagToCompanion(tag));
    return tag;
  }

  @override
  Future<void> softDeleteTag(String id) {
    return _dao.softDeleteTag(id, dateTimeToMillis(_now()));
  }
}

class _SystemTagSeed {
  const _SystemTagSeed({
    required this.name,
    required this.tagKind,
    required this.colorToken,
    this.iconName,
  });

  final String name;
  final TagKind tagKind;
  final String colorToken;
  final String? iconName;
}

const _systemTagSeeds = [
  _SystemTagSeed(
    name: '日常',
    tagKind: TagKind.normal,
    colorToken: 'primary',
    iconName: 'event_note',
  ),
  _SystemTagSeed(
    name: '晒太阳',
    tagKind: TagKind.normal,
    colorToken: 'primary',
    iconName: 'wb_sunny',
  ),
  _SystemTagSeed(
    name: '吃草',
    tagKind: TagKind.normal,
    colorToken: 'primary',
    iconName: 'grass',
  ),
  _SystemTagSeed(
    name: '剪指甲',
    tagKind: TagKind.normal,
    colorToken: 'secondary',
    iconName: 'content_cut',
  ),
  _SystemTagSeed(
    name: '看兽医',
    tagKind: TagKind.normal,
    colorToken: 'warning',
    iconName: 'medical_services',
  ),
  _SystemTagSeed(
    name: '里程碑',
    tagKind: TagKind.milestone,
    colorToken: 'secondary',
    iconName: 'flag',
  ),
];
