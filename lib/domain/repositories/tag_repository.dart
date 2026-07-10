import '../models/raby_enums.dart';
import '../models/tag.dart';

abstract interface class TagRepository {
  Stream<List<Tag>> watchAvailableTags(String rabbitId);
  Future<List<Tag>> getAvailableTags(String rabbitId);
  Future<void> ensureSystemTagsSeeded();
  Future<Tag> createCustomTag({
    required String rabbitId,
    required String name,
    TagKind tagKind = TagKind.normal,
  });
  Future<void> softDeleteTag(String id);
}
