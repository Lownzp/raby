import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MediaStorageService {
  const MediaStorageService();

  Future<String> diaryMediaRelativePath({
    required String diaryId,
    required String mediaId,
    String extension = 'jpg',
  }) async {
    return p.posix.join(
      'media',
      'diaries',
      diaryId,
      '$mediaId.${_normalizeExtension(extension)}',
    );
  }

  Future<String> rabbitAvatarRelativePath({
    required String rabbitId,
    required String mediaId,
    String extension = 'jpg',
  }) async {
    return p.posix.join(
      'media',
      'rabbits',
      rabbitId,
      'avatar',
      '$mediaId.${_normalizeExtension(extension)}',
    );
  }

  Future<File> resolve(String relativePath) async {
    final root = await _documentsDirectory();
    return File(p.join(root.path, p.fromUri(Uri(path: relativePath))));
  }

  Future<String> copyToRelativePath({
    required File source,
    required String relativePath,
  }) async {
    final target = await resolve(relativePath);
    await target.parent.create(recursive: true);
    await source.copy(target.path);
    return relativePath;
  }

  Future<void> deleteRelativePath(String relativePath) async {
    final target = await resolve(relativePath);
    if (await target.exists()) {
      await target.delete();
    }
  }

  Future<Directory> _documentsDirectory() {
    return getApplicationDocumentsDirectory();
  }

  String _normalizeExtension(String extension) {
    final normalized = extension.trim().replaceFirst(RegExp(r'^\.'), '');
    return normalized.isEmpty ? 'jpg' : normalized.toLowerCase();
  }
}
