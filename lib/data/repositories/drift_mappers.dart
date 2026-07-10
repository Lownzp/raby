import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/diary.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/diary_media.dart';
import '../../domain/models/rabbit.dart';
import '../../domain/models/raby_enums.dart';
import '../../domain/models/tag.dart';
import '../../domain/models/weight_record.dart';
import '../database/app_database.dart';

int dateTimeToMillis(DateTime value) {
  return value.toUtc().millisecondsSinceEpoch;
}

DateTime millisToDateTime(int value) {
  return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
}

Value<T?> nullableValue<T>(T? value) => Value<T?>(value);

Rabbit rabbitFromRow(RabbitRow row) {
  return Rabbit(
    id: row.id,
    name: row.name,
    sex: RabbitSex.fromValue(row.sex),
    birthDate: row.birthDate,
    adoptedDate: row.adoptedDate,
    breed: row.breed,
    furColor: row.furColor,
    avatarPath: row.avatarPath,
    source: row.source,
    neuteredStatus: row.neuteredStatus == null
        ? null
        : NeuteredStatus.fromValue(row.neuteredStatus!),
    neuteredDate: row.neuteredDate,
    chipNumber: row.chipNumber,
    initialWeightGrams: row.initialWeightGrams,
    personalityTags: _decodeStringList(row.personalityTagsJson),
    favoriteFoods: row.favoriteFoods,
    favoriteToys: row.favoriteToys,
    passedAwayDate: row.passedAwayDate,
    createdAt: millisToDateTime(row.createdAt),
    updatedAt: millisToDateTime(row.updatedAt),
    deletedAt: row.deletedAt == null ? null : millisToDateTime(row.deletedAt!),
  );
}

RabbitsCompanion rabbitToCompanion(Rabbit rabbit) {
  return RabbitsCompanion.insert(
    id: rabbit.id,
    name: rabbit.name.trim(),
    sex: rabbit.sex.value,
    birthDate: nullableValue(rabbit.birthDate),
    adoptedDate: nullableValue(rabbit.adoptedDate),
    breed: rabbit.breed.trim(),
    furColor: rabbit.furColor.trim(),
    avatarPath: nullableValue(rabbit.avatarPath),
    source: nullableValue(rabbit.source),
    neuteredStatus: nullableValue(rabbit.neuteredStatus?.value),
    neuteredDate: nullableValue(rabbit.neuteredDate),
    chipNumber: nullableValue(rabbit.chipNumber),
    initialWeightGrams: nullableValue(rabbit.initialWeightGrams),
    personalityTagsJson: nullableValue(
      rabbit.personalityTags.isEmpty
          ? null
          : jsonEncode(rabbit.personalityTags),
    ),
    favoriteFoods: nullableValue(rabbit.favoriteFoods),
    favoriteToys: nullableValue(rabbit.favoriteToys),
    passedAwayDate: nullableValue(rabbit.passedAwayDate),
    createdAt: dateTimeToMillis(rabbit.createdAt),
    updatedAt: dateTimeToMillis(rabbit.updatedAt),
    deletedAt: nullableValue(
      rabbit.deletedAt == null ? null : dateTimeToMillis(rabbit.deletedAt!),
    ),
  );
}

Diary diaryFromRow(DiaryRow row) {
  return Diary(
    id: row.id,
    rabbitId: row.rabbitId,
    recordedAt: millisToDateTime(row.recordedAt),
    content: row.content,
    createdAt: millisToDateTime(row.createdAt),
    updatedAt: millisToDateTime(row.updatedAt),
    deletedAt: row.deletedAt == null ? null : millisToDateTime(row.deletedAt!),
  );
}

DiariesCompanion diaryToCompanion(Diary diary) {
  return DiariesCompanion.insert(
    id: diary.id,
    rabbitId: diary.rabbitId,
    recordedAt: dateTimeToMillis(diary.recordedAt),
    content: nullableValue(diary.content?.trim()),
    createdAt: dateTimeToMillis(diary.createdAt),
    updatedAt: dateTimeToMillis(diary.updatedAt),
    deletedAt: nullableValue(
      diary.deletedAt == null ? null : dateTimeToMillis(diary.deletedAt!),
    ),
  );
}

DiaryMedia diaryMediaFromRow(DiaryMediaRow row) {
  return DiaryMedia(
    id: row.id,
    diaryId: row.diaryId,
    mediaType: MediaType.fromValue(row.mediaType),
    relativePath: row.relativePath,
    thumbnailPath: row.thumbnailPath,
    mimeType: row.mimeType,
    width: row.width,
    height: row.height,
    fileSizeBytes: row.fileSizeBytes,
    durationMs: row.durationMs,
    sortOrder: row.sortOrder,
    createdAt: millisToDateTime(row.createdAt),
    updatedAt: millisToDateTime(row.updatedAt),
    deletedAt: row.deletedAt == null ? null : millisToDateTime(row.deletedAt!),
  );
}

DiaryMediaItemsCompanion diaryMediaToCompanion(DiaryMedia media) {
  return DiaryMediaItemsCompanion.insert(
    id: media.id,
    diaryId: media.diaryId,
    mediaType: media.mediaType.value,
    relativePath: media.relativePath,
    thumbnailPath: nullableValue(media.thumbnailPath),
    mimeType: nullableValue(media.mimeType),
    width: nullableValue(media.width),
    height: nullableValue(media.height),
    fileSizeBytes: nullableValue(media.fileSizeBytes),
    durationMs: nullableValue(media.durationMs),
    sortOrder: media.sortOrder,
    createdAt: dateTimeToMillis(media.createdAt),
    updatedAt: dateTimeToMillis(media.updatedAt),
    deletedAt: nullableValue(
      media.deletedAt == null ? null : dateTimeToMillis(media.deletedAt!),
    ),
  );
}

Tag tagFromRow(TagRow row) {
  return Tag(
    id: row.id,
    rabbitId: row.rabbitId,
    name: row.name,
    tagKind: TagKind.fromValue(row.tagKind),
    isSystem: row.isSystem,
    colorToken: row.colorToken,
    iconName: row.iconName,
    sortOrder: row.sortOrder,
    createdAt: millisToDateTime(row.createdAt),
    updatedAt: millisToDateTime(row.updatedAt),
    deletedAt: row.deletedAt == null ? null : millisToDateTime(row.deletedAt!),
  );
}

TagsCompanion tagToCompanion(Tag tag) {
  return TagsCompanion.insert(
    id: tag.id,
    rabbitId: nullableValue(tag.rabbitId),
    name: tag.name.trim(),
    tagKind: tag.tagKind.value,
    isSystem: Value(tag.isSystem),
    colorToken: nullableValue(tag.colorToken),
    iconName: nullableValue(tag.iconName),
    sortOrder: Value(tag.sortOrder),
    createdAt: dateTimeToMillis(tag.createdAt),
    updatedAt: dateTimeToMillis(tag.updatedAt),
    deletedAt: nullableValue(
      tag.deletedAt == null ? null : dateTimeToMillis(tag.deletedAt!),
    ),
  );
}

WeightRecord weightRecordFromRow(WeightRecordRow row) {
  return WeightRecord(
    id: row.id,
    rabbitId: row.rabbitId,
    recordedAt: millisToDateTime(row.recordedAt),
    weightGrams: row.weightGrams,
    note: row.note,
    photoPath: row.photoPath,
    bcsScore: row.bcsScore,
    createdAt: millisToDateTime(row.createdAt),
    updatedAt: millisToDateTime(row.updatedAt),
    deletedAt: row.deletedAt == null ? null : millisToDateTime(row.deletedAt!),
  );
}

WeightRecordsCompanion weightRecordToCompanion(WeightRecord record) {
  return WeightRecordsCompanion.insert(
    id: record.id,
    rabbitId: record.rabbitId,
    recordedAt: dateTimeToMillis(record.recordedAt),
    weightGrams: record.weightGrams,
    note: nullableValue(record.note?.trim()),
    photoPath: nullableValue(record.photoPath),
    bcsScore: nullableValue(record.bcsScore),
    createdAt: dateTimeToMillis(record.createdAt),
    updatedAt: dateTimeToMillis(record.updatedAt),
    deletedAt: nullableValue(
      record.deletedAt == null ? null : dateTimeToMillis(record.deletedAt!),
    ),
  );
}

DiaryEntry diaryEntryFromBundle(DiaryBundleRow bundle) {
  return DiaryEntry(
    diary: diaryFromRow(bundle.diary),
    media: bundle.media.map(diaryMediaFromRow).toList(growable: false),
    tags: bundle.tags.map(tagFromRow).toList(growable: false),
  );
}

List<String> _decodeStringList(String? jsonValue) {
  if (jsonValue == null || jsonValue.isEmpty) {
    return const [];
  }
  final decoded = jsonDecode(jsonValue);
  if (decoded is! List) {
    return const [];
  }
  return decoded.whereType<String>().toList(growable: false);
}
